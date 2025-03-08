defmodule CanClient.FrameWriter do
  use GenServer
  require Logger

  @port 29536
  @max_buf_len 50

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    VintageNet.configure("can0", %{
      type: VintageNetCan,
      can: %{bitrate: 500_000},
      socket: %{
        port: @port,
        can_interfaces: ["can0"],
        linked_interface: "lo"
      }
    })

    send(self(), :setup)

    {:ok, {nil, nil, []}}
  end

  defp channel_connection() do
    socket_opts = [
      # url: "ws://desktop.local:4000/socket/websocket"
      url: "wss://12cf6ca882b9.ngrok.app/socket/websocket"
    ]

    {:ok, socket} = PhoenixClient.Socket.start_link(socket_opts)

    with {:ok, socket} <- await_connected(socket, 0, 4) do
      topic = "can:veh_bb3e5caf-5849-4ee8-bed5-b12c3c160006"
      {:ok, _response, channel} = PhoenixClient.Channel.join(socket, topic)

      {:ok, channel}
    end
  end

  defp can_connection() do
    {:ok, socket} = Cand.Socket.start_link()
    :hi = Cand.Socket.connect(socket, {127, 0, 0, 1}, @port)

    [:ok] = Cand.Protocol.open(socket, "can0")
    Cand.Protocol.raw_mode(socket)
    socket
  end

  defp dump_frames(channel, buf) do
    b =
      Enum.map(buf, fn
        {:frame, {id, time, data}} ->
          [id, time, data]

        {:error, _} ->
          []
      end)
      |> :erlang.term_to_binary(compressed: 9)

    res =
      PhoenixClient.Channel.push_async(
        channel,
        "frames",
        %{
          "frames" => Base.encode64(b)
        }
      )

    Logger.info("Sent frames #{inspect(res)} #{byte_size(b)} bytes")
  end

  def handle_info(:setup, state) do
    case channel_connection() do
      {:ok, channel} ->
        state = {channel, can_connection(), []}
        # let's begin
        send(self(), :tick)
        {:noreply, state}

      {:error, e} ->
        Logger.warn("Failed to connect to socket #{inspect(e)}")
        send(self(), :setup)
        Process.sleep(5_000)
        {:noreply, state}
    end
  end

  def handle_info(:tick, {channel, can, buf}) do
    frames = Cand.Protocol.receive_frame(can)
    Logger.info("Got #{length(frames)} CAN frames")

    buf = buf ++ frames

    buf =
      if length(buf) > @max_buf_len do
        dump_frames(channel, buf)
        []
      else
        buf
      end

    send(self(), :tick)
    {:noreply, {channel, can, buf}}
  end

  defp await_connected(socket, max_attempts, max_attempts) do
    {:error, "Failed to connect to phx channel after #{max_attempts} tries"}
  end

  defp await_connected(socket, attempts, max_attempts) do
    if not PhoenixClient.Socket.connected?(socket) do
      Process.sleep(500 * attempts)
      Logger.info("Await connection attempt #{attempts}/#{max_attempts}")
      await_connected(socket, attempts + 1, max_attempts)
    else
      {:ok, socket}
    end
  end
end

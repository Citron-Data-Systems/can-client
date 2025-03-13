defmodule CanClient.FrameWriter do
  use GenServer
  require Logger

  @port 29536

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

    {:ok, {nil, nil}}
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

  def frame_loop(parent, socket) do
    frames = Cand.Protocol.receive_frame(socket)
    send(parent, {:frames, frames})
    frame_loop(parent, socket)
  end

  defp can_connection() do
    parent = self()
    spawn_link(fn ->
      {:ok, socket} = Cand.Socket.start_link()
      :hi = Cand.Socket.connect(socket, {127, 0, 0, 1}, @port)

      [:ok] = Cand.Protocol.open(socket, "can0")
      Cand.Protocol.raw_mode(socket)
      frame_loop(parent, socket)

    end)
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
        state = {channel, can_connection()}
        {:noreply, state}

      {:error, e} ->
        Logger.warning("Failed to connect to socket #{inspect(e)}")
        send(self(), :setup)
        Process.sleep(5_000)
        {:noreply, state}
    end
  end

  def handle_info({:frames, buf}, {channel, can}) do
    Logger.info(
      "Got #{length(buf)} CAN frames #{inspect(Enum.map(buf, fn {:frame, {id, _, _}} -> id end))}"
    )
    dump_frames(channel, buf)
    {:noreply, {channel, can}}
  end

  defp await_connected(_socket, max_attempts, max_attempts) do
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

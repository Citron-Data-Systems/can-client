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
      url: "wss://5bf6db8c56a8.ngrok.app/socket/websocket"
    ]

    {:ok, socket} = PhoenixClient.Socket.start_link(socket_opts)
    await_connected(socket, 0, 50)

    topic = "can:veh_bb3e5caf-5849-4ee8-bed5-b12c3c160006"
    {:ok, _response, channel} = PhoenixClient.Channel.join(socket, topic)

    channel
  end

  defp can_connection() do
    {:ok, socket} = Cand.Socket.start_link()
    :hi = Cand.Socket.connect(socket, {127, 0, 0, 1}, @port)

    [:ok] = Cand.Protocol.open(socket, "can0")
    Cand.Protocol.raw_mode(socket)
    socket
  end

  def handle_info(:setup, socket) do
    state = {channel_connection(), can_connection()}
    # let's begin
    send(self(), :tick)
    {:noreply, state}
  end

  def handle_info(:tick, {channel, can}) do
    frames = Cand.Protocol.receive_frame(can)
    Logger.info("Got #{length(frames)} CAN frames")

    to_send = Enum.flat_map(frames, fn
      {:frame, {id, time, data}} ->
        [%{id: id, time: time, data: Base.encode64(data)}]

      {:error, _} ->
        []
    end)

    res = PhoenixClient.Channel.push_async(
      channel,
      "frames",
      %{
        "frames" => to_send
      }
    )
    Logger.info("Sent frames: #{inspect res}")

    send(self(), :tick)
    {:noreply, {channel, can}}
  end

  defp await_connected(socket, max_attempts, max_attempts) do
    raise RuntimeError, message: "Failed to connect to phx channel after #{max_attempts} tries"
  end

  defp await_connected(socket, attempts, max_attempts) do
    if not PhoenixClient.Socket.connected?(socket) do
      Process.sleep(500)
      Logger.info("Await connection")
      await_connected(socket, attempts + 1, max_attempts)
    else
      socket
    end
  end
end

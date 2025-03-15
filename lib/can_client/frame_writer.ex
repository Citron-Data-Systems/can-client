defmodule CanClient.FrameWriter do
  alias PhoenixClient.Message
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
      url: "ws://192.168.1.232:4000/socket/websocket"
      # url: "ws://desktop.local:4000/socket/websocket"
      # url: "wss://12cf6ca882b9.ngrok.app/socket/websocket"
    ]

    Logger.info("Connecting to socket #{inspect(socket_opts)}")
    {:ok, socket} = PhoenixClient.Socket.start_link(socket_opts)

    with {:ok, socket} <- await_connected(socket, 0, 4) do
      topic = "can:veh_bb3e5caf-5849-4ee8-bed5-b12c3c160006"
      Logger.info("Connection to channel #{topic}")
      {:ok, _response, channel} = PhoenixClient.Channel.join(socket, topic)

      {:ok, channel}
    end
  end

  def frame_read_loop(parent, socket) do
    frames = Cand.Protocol.receive_frame(socket)
    send(parent, {:frames, frames})
    frame_read_loop(parent, socket)
  end

  def frame_write_loop(parent, socket) do
    receive do
      {:write_frame, can_id, frame, ref, reply_to} ->
        res =
          try do
            res = Cand.Protocol.send_frame(socket, can_id, frame)
            Logger.info("Sent a frame to the bus #{inspect(res)}")
            :ok
          catch
            :exit, e ->
              Logger.error("Failed to send frame: #{inspect(e)}")
              {:error, :timeout}
          end

        send(reply_to, {:meta_result, ref, res})
        blink_frame_sent_to_bus()
    end

    frame_write_loop(parent, socket)
  end

  defp send_frame_to_bus(pid, can_id, frame, ref) do
    send(pid, {:write_frame, can_id, frame, ref, self()})
  end

  defp can_connection() do
    Logger.info("Setting up CAN connection")
    parent = self()

    spawn_link(fn ->
      {:ok, socket} = Cand.Socket.start_link()
      :hi = Cand.Socket.connect(socket, {127, 0, 0, 1}, @port)

      [:ok] = Cand.Protocol.open(socket, "can0")
      Cand.Protocol.raw_mode(socket)
      Logger.info("CAN Connection up at #{inspect(socket)}")
      spawn_link(fn -> frame_read_loop(parent, socket) end)

      frame_write_loop(parent, socket)
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
    blink_frames_sent_to_server()
    {:noreply, {channel, can}}
  end

  def handle_info(
        %Message{
          event: "meta",
          payload: %{"message" => buf, "frame_id" => frame_id, "ref" => ref}
        },
        {channel, can}
      ) do
    Logger.info("Got message meta #{frame_id} #{buf}")

    send_frame_to_bus(can, frame_id, buf, ref)
    {:noreply, {channel, can}}
  end

  def handle_info({:meta_result, ref, res}, {channel, can}) do
    Logger.info("Meta result #{inspect(res)}")

    payload =
      case res do
        :ok -> %{type: :ok, ref: ref, payload: %{}}
        {:error, :timeout} -> %{type: :error, ref: ref, payload: %{reason: "CAN send attempted but timed out with no ack"}}
      end

    PhoenixClient.Channel.push_async(
      channel,
      "meta_result",
      payload
    )

    {:noreply, {channel, can}}
  end

  def handle_info(%PhoenixClient.Message{event: "meta_result"}, state) do
    {:noreply, state}
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

  defp blink_frames_sent_to_server() do
    Delux.render(
      Delux.Effects.number_blink(:red, 5, blink_on_duration: 80, blink_off_duration: 80)
      |> Map.put(:mode, :one_shot)
    )
  end

  defp blink_frame_sent_to_bus() do
    Delux.render(
      Delux.Effects.number_blink(:green, 5, blink_on_duration: 100, blink_off_duration: 100)
      |> Map.put(:mode, :one_shot)
    )
  end
end

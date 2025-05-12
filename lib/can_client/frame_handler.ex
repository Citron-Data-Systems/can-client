defmodule CanClient.FrameHandler do
  alias CanClient.FrameWriter.{PhxChannelWriter, WorldStateWriter}
  alias CanClient.CanNet
  use GenServer
  require Logger

  @framebuf_size 10

  defmodule FrameWriter do
    @callback init() :: {:ok, any} | {:stop, atom}
    @callback handle_frames(frames :: list, state :: any()) :: any()
  end

  @receivers [
    PhxChannelWriter,
    WorldStateWriter
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    send(self(), :setup)

    {:ok, {%{}, nil}}
  end



  defp frame_read_loop(parent, socket, buf) do
    frames = Cand.Protocol.receive_frame(socket)
    buf = frames ++ buf

    buf =
      if length(buf) > @framebuf_size do
        send(parent, {:frames, buf})
        []
      else
        buf
      end

    frame_read_loop(parent, socket, buf)
  end
  defp frame_write_loop(parent, socket) do
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
        # blink_frame_sent_to_bus()
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
      {:ok, socket} = CanNet.open_socket()
      spawn_link(fn -> frame_read_loop(parent, socket, []) end)
      frame_write_loop(parent, socket)
    end)
  end


  def handle_info(:setup, {r_state, _}) do
    r_state =
      Enum.reduce(@receivers, r_state, fn mod, acc ->
        {:ok, state} = mod.init()
        Map.put(acc, mod, state)
      end)

    {:noreply, {r_state, can_connection()}}
  end

  def handle_info({:frames, buf}, {receivers, can}) do
    Logger.info(
      "Got #{length(buf)} CAN frames #{inspect(Enum.map(buf, fn {:frame, {id, _, _}} -> id end))}"
    )

    r_state =
      Enum.reduce(receivers, fn {r, state}, acc ->
        Map.put(acc, r, r.handle_frames(buf, state))
      end)

    # update_worldstate(buf)
    # dump_frames(channel, buf)
    # blink_frames_sent_to_server()
    {:noreply, {r_state, can}}
  end

  # defp blink_frame_sent_to_bus() do
  #   Delux.render(
  #     Delux.Effects.number_blink(:green, 5, blink_on_duration: 100, blink_off_duration: 100)
  #     |> Map.put(:mode, :one_shot)
  #   )
  # end
  # def handle_info(
  #       %Message{
  #         event: "meta",
  #         payload: %{"message" => buf, "frame_id" => frame_id, "ref" => ref}
  #       },
  #       {channel, can}
  #     ) do
  #   Logger.info("Got message meta #{frame_id} #{buf}")

  #   send_frame_to_bus(can, frame_id, buf, ref)
  #   {:noreply, {channel, can}}
  # end

  # def handle_info({:meta_result, ref, res}, {channel, can}) do
  #   Logger.info("Meta result #{inspect(res)}")

  #   payload =
  #     case res do
  #       :ok ->
  #         %{type: :ok, ref: ref, payload: %{}}

  #       {:error, :timeout} ->
  #         %{
  #           type: :error,
  #           ref: ref,
  #           payload: %{reason: "CAN send attempted but timed out with no ack"}
  #         }
  #     end

  #   PhoenixClient.Channel.push_async(
  #     channel,
  #     "meta_result",
  #     payload
  #   )

  #   {:noreply, {channel, can}}
  # end

  # def handle_info(%PhoenixClient.Message{event: "meta_result"}, state) do
  #   {:noreply, state}
  # end
end

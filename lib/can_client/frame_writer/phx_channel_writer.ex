defmodule CanClient.FrameHandler.PhxChannelWriter do
  alias CanClient.CitronAPI

  require Logger

  @behaviour CanClient.FrameHandler.FrameHandler
  @batch_size 30
  def init() do
    pid =
      spawn_link(fn ->
        run()
      end)

    {:ok, {pid, []}}
  end

  def handle_frames(frames, {pid, buf}) do
    acc = buf ++ frames

    if length(acc) > @batch_size do
      send(pid, {:frames, acc})
      {pid, []}
    else
      {pid, acc}
    end
  end

  def run() do
    topic = "can:#{CanClient.Application.get_vehicle_id()}"
    Logger.info("Attempt to join #{topic}")

    # if there is a big backlog of frames, just kill them
    clear_frames()

    case CitronAPI.join(topic) do
      {:ok, _resp, channel} ->
        Logger.info("Joined the vehicle channel at #{inspect(channel)}, awaiting frames")
        recv_frames(channel)

      fail ->
        Logger.info("Failed to join the vehicle channel, retrying indefinitely #{inspect(fail)}")
        Process.sleep(5000)
        run()
    end
  end

  defp clear_frames() do
    receive do
      {:frames, _} ->
        clear_frames()
        # code
    after
      0 ->
        :ok
    end
  end

  defp recv_frames(channel) do
    receive do
      %PhoenixClient.Message{
        payload: %{
          "response" => %{"reason" => "unmatched topic"},
          "status" => "error"
        }
      } ->
        raise RuntimeError, message: "Channel error, restart me"

      {:frames, frames} ->
        b = :erlang.term_to_binary(frames, compressed: 9)

        res =
          PhoenixClient.Channel.push_async(
            channel,
            "frames",
            %{
              "frames" => Base.encode64(b)
            }
          )

        # blink_frames_sent_to_server()
        Logger.info("Sent frames #{inspect(res)} #{byte_size(b)} bytes to #{inspect(channel)}")
        recv_frames(channel)

      other ->
        Logger.warning("Ignoring message #{inspect(other)}")
        recv_frames(channel)
    end
  end

  # This is super slow...need to debounce
  # defp blink_frames_sent_to_server() do
  #   Delux.render(
  #     Delux.Effects.number_blink(:red, 5, blink_on_duration: 80, blink_off_duration: 80)
  #     |> Map.put(:mode, :one_shot)
  #   )
  # end
end

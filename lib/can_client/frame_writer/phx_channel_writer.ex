defmodule CanClient.FrameWriter.PhxChannelWriter do
  alias CanClient.CitronAPI
  alias PhoenixClient.Message
  require Logger

  @behaviour CanClient.FrameHandler.FrameWriter

  def init() do
    spawn_link(fn ->
      run()
    end)
  end

  def run() do
    topic = "can:#{CanClient.Application.get_vehicle_id()}"

    clear_frames()

    case CitronAPI.join(topic) do
      {:ok, _resp, channel} ->
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
        nil
        # code
    end
  end

  defp recv_frames(channel) do
    receive do
      {:frames, frames} ->
        b =
          Enum.map(frames, fn
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

        blink_frames_sent_to_server()
        Logger.info("Sent frames #{inspect(res)} #{byte_size(b)} bytes")
    end
  end

  def handle_frames(frames, pid) do
    send(pid, {:frames, frames})
  end

  defp blink_frames_sent_to_server() do
    Delux.render(
      Delux.Effects.number_blink(:red, 5, blink_on_duration: 80, blink_off_duration: 80)
      |> Map.put(:mode, :one_shot)
    )
  end
end

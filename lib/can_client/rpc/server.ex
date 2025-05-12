defmodule CanClient.RPC.Server do
  use GRPC.Server,
    service: CanClient.RPC.Service,
    http_transcode: true

  alias CanClient.Rpc.Util
  alias CanClient.FrameWriter.WorldStateWriter.DefinitionManager
  alias CanClient.FrameWriter.WorldStateWriter.StateHolder
  alias GRPC.Server
  require Logger

  @doc """
  gRPC function used to fetch basic system information
  """
  def echo(_request, _stream) do
    %CanClient.EchoResult{
      message: "bugs"
    }
  end

  defp sendit(stream, i) do
    Server.send_reply(stream, %CanClient.EchoResult{
      message: "hello #{i}"
    })

    Process.sleep(500)
    sendit(stream, i + 1)
  end

  def stream_echo(_request, stream) do
    sendit(stream, 0)
  end

  def publish_signals(stream) do
    receive do
      {StateHolder, _signal, value} ->
        Server.send_reply(stream, %CanClient.SignalValue{
          value: value
        })
    end

    publish_signals(stream)
  end

  def stream_signal(request, stream) do
    {_pid, ref} =
      spawn_monitor(fn ->
        Logger.info("Streaming signals from me")
        StateHolder.sub([request.signal])
        publish_signals(stream)
      end)

    receive do
      {:DOWN, ^ref, :process, _pid, reason} ->
        Logger.info("Done streaming signals #{inspect(reason)}")
    end
  end




  def vehicle_meta(_request, _stream) do
    {:ok, vehicle} = DefinitionManager.get_vehicle()
    Util.api_to_proto(vehicle) |> IO.inspect
  end
end

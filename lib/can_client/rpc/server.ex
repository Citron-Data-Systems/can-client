defmodule CanClient.RPC.Server do
  use GRPC.Server,
    service: CanClient.RPC.Service,
    http_transcode: true

  alias CanClient.FrameHandler.VehicleMetaChannel
  alias CanClient.Rpc.Util
  alias CanClient.FrameHandler.WorldStateWriter.DefinitionManager
  alias CanClient.FrameHandler.WorldStateWriter.StateHolder
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

  def publish_text(stream) do
    receive do
      {StateHolder, _signal, value} ->
        Logger.info("Publish Text: #{inspect value}")
        Server.send_reply(stream, Util.to_text_value(value))
    end

    publish_text(stream)
  end


  def stream_text(_request, stream) do
    {_pid, ref} =
      spawn_monitor(fn ->
        Logger.info("Streaming text messages from me")
        StateHolder.sub([VehicleMetaChannel.message_virtual_signal()])
        publish_text(stream)
      end)

    receive do
      {:DOWN, ^ref, :process, _pid, reason} ->
        Logger.info("Done streaming signals #{inspect(reason)}")
    end
  end

  defp ok(result_type, key, value) do
    struct(result_type, %{result: {key, value}})
  end

  defp error(result_type, error_key, error_struct) do
    struct(result_type, %{
      result: {:error, %CanClient.ResultError{error: {error_key, error_struct}}}
    })

  end

  defp not_found(result_type), do: error(result_type, :not_found, %CanClient.NotFound{})
  defp offline(result_type), do: error(result_type, :offline, %CanClient.Offline{})

  defp publish_vehicle_defs(stream) do
    receive do
      {StateHolder, _topic, vehicle} ->
        Logger.info("Sending new vehicle defn to ui")

        Server.send_reply(
          stream,
          ok(
            CanClient.VehicleMetaResult,
            :vehicle,
            Util.api_to_proto(vehicle)
          )
        )

        publish_vehicle_defs(stream)
        # code
    end
  end

  def vehicle_meta(_request, stream) do
    case VehicleMetaChannel.get_vehicle() do
      {:ok, vehicle} ->
        Server.send_reply(
          stream,
          ok(
            CanClient.VehicleMetaResult,
            :vehicle,
            Util.api_to_proto(vehicle)
          )
        )


      {:error, :offline} ->
        Server.send_reply(stream, offline(CanClient.VehicleMetaResult))
      {:error, :not_found} ->
        Server.send_reply(stream, not_found(CanClient.VehicleMetaResult))
    end

    {_, ref} =
      spawn_monitor(fn ->
        Logger.info("Streaming vehicle defs from me")
        StateHolder.sub([VehicleMetaChannel.emitter_topic()])
        publish_vehicle_defs(stream)
      end)

    receive do
      {:DOWN, ^ref, :process, _pid, reason} ->
        Logger.info("Done streaming signals #{inspect(reason)}")
    end
  end
end

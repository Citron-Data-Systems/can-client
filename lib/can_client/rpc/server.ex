
defmodule CanClient.RPC.Server do
  use GRPC.Server,
    service: CanClient.RPC.Service,
    http_transcode: true

  @doc """
  gRPC function used to fetch basic system information
  """
  def echo(_request, _stream) do
    %CanClient.EchoResult{
      message: "hello world from elixir"
    }
  end

  # def stream_logs(_request, stream) do
  #   GenServer.start_link(CanClient.LogServer, stream: stream)

  #   Task.async(fn ->
  #     Process.sleep(:infinity)
  #     :ok
  #   end)
  #   |> Task.await(:infinity)
  # end

end

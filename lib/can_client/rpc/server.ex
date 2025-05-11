defmodule CanClient.RPC.Server do
  use GRPC.Server,
    service: CanClient.RPC.Service,
    http_transcode: true

  alias GRPC.Server

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
    |> IO.inspect()

    Process.sleep(500)
    sendit(stream, i + 1)
  end

  def stream_echo(_request, stream) do
    sendit(stream, 0)
  end
end

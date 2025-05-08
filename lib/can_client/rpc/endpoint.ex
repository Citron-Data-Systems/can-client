defmodule CanClient.RPC.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Server.Interceptors.Logger)
  run(CanClient.RPC.Server)
end

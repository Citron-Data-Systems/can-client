defmodule CanClient.Empty do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3
end

defmodule CanClient.EchoResult do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :message, 1, type: :string
end

defmodule CanClient.RPC.Service do
  @moduledoc false

  use GRPC.Service, name: "CanClient.RPC", protoc_gen_elixir_version: "0.14.1"

  rpc(:Echo, CanClient.Empty, CanClient.EchoResult, %{
    http: %{
      type: Google.Api.PbExtension,
      value: %Google.Api.HttpRule{
        selector: "",
        body: "",
        additional_bindings: [],
        response_body: "",
        pattern: {:get, "/echo"},
        __unknown_fields__: []
      }
    }
  })

  rpc(:StreamEcho, CanClient.Empty, stream(CanClient.EchoResult), %{
    http: %{
      type: Google.Api.PbExtension,
      value: %Google.Api.HttpRule{
        selector: "",
        body: "",
        additional_bindings: [],
        response_body: "",
        pattern: {:get, "/streamEcho"},
        __unknown_fields__: []
      }
    }
  })
end

defmodule CanClient.RPC.Stub do
  @moduledoc false

  use GRPC.Stub, service: CanClient.RPC.Service
end

defmodule CanClient.Empty do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3
end

defmodule CanClient.EchoResult do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :message, 1, type: :string
end

defmodule CanClient.SignalValue do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :value, 2, type: :float
end

defmodule CanClient.SignalSubscription do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :signal, 1, type: :string
end

defmodule CanClient.LayoutInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :x, 1, type: :int32
  field :y, 2, type: :int32
  field :w, 3, type: :int32
  field :h, 4, type: :int32
end

defmodule CanClient.Signal do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :name, 1, type: :string
  field :unit, 2, type: :string
  field :range_min, 3, type: :double, json_name: "rangeMin"
  field :range_max, 4, type: :double, json_name: "rangeMax"
  field :id, 5, type: :string
end

defmodule CanClient.DBCMessage do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :can_id, 2, type: :int64, json_name: "canId"
  field :signals, 3, repeated: true, type: CanClient.Signal
end

defmodule CanClient.DBCDef do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :content, 2, type: :string
  field :filename, 3, type: :string
  field :messages, 4, repeated: true, type: CanClient.DBCMessage
end

defmodule CanClient.LineChartWidget do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :title, 1, proto3_optional: true, type: :string
  field :columns, 2, repeated: true, type: :string
  field :layout, 3, type: CanClient.LayoutInfo
end

defmodule CanClient.GaugeZone do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :start, 1, type: :double
  field :end, 2, type: :double
  field :color, 3, type: :string
end

defmodule CanClient.GaugeStyle do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :zones, 4, repeated: true, type: CanClient.GaugeZone
  field :style_type, 5, type: :string, json_name: "styleType"
end

defmodule CanClient.GaugeWidget do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :title, 1, proto3_optional: true, type: :string
  field :columns, 2, repeated: true, type: :string
  field :layout, 3, type: CanClient.LayoutInfo
  field :style, 4, type: CanClient.GaugeStyle
end

defmodule CanClient.DashWidget do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  oneof :widget, 0

  field :line_chart, 1, type: CanClient.LineChartWidget, json_name: "lineChart", oneof: 0
  field :gauge, 2, type: CanClient.GaugeWidget, oneof: 0
end

defmodule CanClient.Dashboard do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :uid, 1, type: :string
  field :name, 2, type: :string
  field :widgets, 3, repeated: true, type: CanClient.DashWidget
end

defmodule CanClient.Vehicle do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  field :name, 2, type: :string
  field :avatar, 3, type: :string
  field :dbc_defs, 4, repeated: true, type: CanClient.DBCDef, json_name: "dbcDefs"
  field :dashboards, 5, repeated: true, type: CanClient.Dashboard
  field :uid, 6, type: :string
end

defmodule CanClient.NotFound do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3
end

defmodule CanClient.Offline do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3
end

defmodule CanClient.ResultError do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  oneof :error, 0

  field :not_found, 1, type: CanClient.NotFound, json_name: "notFound", oneof: 0
  field :offline, 2, type: CanClient.Offline, oneof: 0
end

defmodule CanClient.VehicleMetaResult do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.14.1", syntax: :proto3

  oneof :result, 0

  field :vehicle, 1, type: CanClient.Vehicle, oneof: 0
  field :error, 2, type: CanClient.ResultError, oneof: 0
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

  rpc(:StreamSignal, CanClient.SignalSubscription, stream(CanClient.SignalValue), %{
    http: %{
      type: Google.Api.PbExtension,
      value: %Google.Api.HttpRule{
        selector: "",
        body: "",
        additional_bindings: [],
        response_body: "",
        pattern: {:get, "/streamSignals"},
        __unknown_fields__: []
      }
    }
  })

  rpc(:VehicleMeta, CanClient.Empty, stream(CanClient.VehicleMetaResult), %{
    http: %{
      type: Google.Api.PbExtension,
      value: %Google.Api.HttpRule{
        selector: "",
        body: "",
        additional_bindings: [],
        response_body: "",
        pattern: {:get, "/vehicleMeta"},
        __unknown_fields__: []
      }
    }
  })
end

defmodule CanClient.RPC.Stub do
  @moduledoc false

  use GRPC.Stub, service: CanClient.RPC.Service
end

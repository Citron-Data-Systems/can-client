import Config

# Add configuration that is only needed when running on the host here.

config :logger, :console,
  handle_sasl_reports: true,
  handle_otp_reports: true,
  truncate: :infinity,
  level: :debug,
  truncate: 1024 * 10,
  format: "$time $metadata[$level] $message\n",
  metadata: [
    :request_id,
    :module,
    :function,
    :pid,
    :vehicle_id,
    :session_id,
    :signal_name
  ]

config :can_client,
  ws_url: "ws://localhost:4020/socket/websocket",
  vehicle_uid: "veh_bb3e5caf-5849-4ee8-bed5-b12c3c160006",
  vehicle_meta_location: "/tmp/vehicle_meta.dets"

config :nerves_runtime,
  kv_backend:
    {Nerves.Runtime.KVBackend.InMemory,
     contents: %{
       # The KV store on Nerves systems is typically read from UBoot-env, but
       # this allows us to use a pre-populated InMemory store when running on
       # host for development and testing.
       #
       # https://hexdocs.pm/nerves_runtime/readme.html#using-nerves_runtime-in-tests
       # https://hexdocs.pm/nerves_runtime/readme.html#nerves-system-and-firmware-metadata

       "nerves_fw_active" => "a",
       "a.nerves_fw_architecture" => "generic",
       "a.nerves_fw_description" => "N/A",
       "a.nerves_fw_platform" => "host",
       "a.nerves_fw_version" => "0.0.0"
     }}

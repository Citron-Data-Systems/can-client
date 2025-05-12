defmodule CanClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defmodule CitronSupervisor do
    use Supervisor

    def start_link([]) do
      Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    @impl true
    def init([]) do
      children = [
        {CanClient.CitronAPI, []}
      ]

      # effectively infinite restarts
      Supervisor.init(children, strategy: :one_for_one, max_restarts: 100_000, max_seconds: 1)
    end
  end

  @impl true
  def start(_type, _args) do
    grpc_server =
      {GRPC.Server.Supervisor, endpoint: CanClient.RPC.Endpoint, port: 50051, start_server: true}

    children =
      [
        grpc_server,
        CitronSupervisor,
        {DynamicSupervisor,
         name: CanClient.DynamicSupervisor,
         strategy: :one_for_one,
         max_restarts: 1000,
         max_seconds: 1}
      ] ++ children(Nerves.Runtime.mix_target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CanClient.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  defp children(:host) do
    [
      {CanClient.MockFrameHandler, []}
    ]
  end

  defp children(_target) do
    dri_card = get_output_card()

    launch_env = %{
      "FLUTTER_DRM_DEVICE" => "/dev/dri/#{dri_card}",
      "GALLIUM_HUD" => "cpu+fps",
      "GALLIUM_HUD_PERIOD" => "0.25",
      "GALLIUM_HUD_SCALE" => "3",
      "GALLIUM_HUD_VISIBLE" => "false",
      "GALLIUM_HUD_TOGGLE_SIGNAL" => "10"
    }

    [
      # Create a child that runs the Flutter embedder.
      # The `:app_name` matches this application, since it contains the AOT bundle at `priv/flutter_app`.
      # See the doc annotation for `create_child/1` for all valid options.
    ]

    [
      {CanClient.CanNet},
      {Delux, [indicators: %{default: %{green: "ACT", red: "PWR"}}]},
      {CanClient.FrameHandler, []},
      NervesFlutterSupport.Flutter.Engine.create_child(
        app_name: :can_client,
        env: launch_env
      )
    ]
  end

  defp get_output_card() do
    Process.sleep(100)
    output = Udev.get_cards() |> Enum.find(fn card -> Udev.is_output_card?(card) end)

    if is_nil(output) do
      get_output_card()
    else
      output
    end
  end

  def get_vehicle_id() do
    Application.get_env(:can_client, :vehicle_uid)
  end
end

defmodule CanClient.MixProject do
  use Mix.Project

  @app :can_client
  @version "0.1.0"
  @all_targets [
    # :host,
    # :rpi5,
    :citron_rpi5
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.17",
      archives: [nerves_bootstrap: "~> 1.13"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {CanClient.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.11.0"},
      {:toolshed, "~> 0.4.0"},

      # Allow Nerves.Runtime on host to support development, testing and CI.
      # See config/host.exs for usage.
      {:nerves_runtime, "~> 0.13.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.1", targets: @all_targets},
      {:vintage_net_wifi, "~> 0.12.0", targets: @all_targets},
      {:cand, github: "Citron-Data-Systems/cand", targets: @all_targets},
      {:vintage_net_can, github: "valiot/vintage_net_can", targets: @all_targets},
      {:phoenix_client, "~> 0.11.1"},
      {:circuits_i2c, "~> 2.1"},
      {:delux, "~> 0.4.1"},
      {:grpc, "~> 0.9"},
      {:protobuf_generate, "~> 0.1.1"},
      {:canbus, github: "rozap/canbus"},
      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      # {:nerves_system_rpi, "~> 1.24", runtime: false, targets: :rpi},
      # {:nerves_system_rpi0, "~> 1.24", runtime: false, targets: :rpi0},
      # {:nerves_system_rpi2, "~> 1.24", runtime: false, targets: :rpi2},
      # {:nerves_system_rpi3, "~> 1.24", runtime: false, targets: :rpi3},
      # {:nerves_system_rpi3a, "~> 1.24", runtime: false, targets: :rpi3a},
      # {:nerves_system_rpi4, "~> 1.24", runtime: false, targets: :rpi4},
      # {:nerves_system_rpi5, "~> 0.2", runtime: false, targets: :rpi5},

      # {:citron_system_rpi5, github: "Citron-Data-Systems/can-client", runtime: false, targets: :rpi5}
      {:citron_system_rpi5,
       github: "Citron-Data-Systems/nerves_system_rpi5",
       runtime: false,
       targets: :citron_rpi5,
       nerves: [compile: true]},
      {:nerves_flutter_support,
       github: "nerves-flutter/nerves_flutter_support",
       branch: "digit/package-mesa3d-mesa3d-headers-bump-version-to-25.0.2"}
      # {:nerves_system_bbb, "~> 2.19", runtime: false, targets: :bbb},
      # {:nerves_system_osd32mp1, "~> 0.15", runtime: false, targets: :osd32mp1},
      # {:nerves_system_x86_64, "~> 1.24", runtime: false, targets: :x86_64},
      # {:nerves_system_grisp2, "~> 0.8", runtime: false, targets: :grisp2},
      # {:nerves_system_mangopi_mq_pro, "~> 0.6", runtime: false, targets: :mangopi_mq_pro}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [
        &Nerves.Release.init/1,
        &NervesFlutterSupport.InstallRuntime.run/1,
        &NervesFlutterSupport.BuildFlutterApp.run/1,
        :assemble
      ],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]],
      flutter: [
        project_dir: "flutter_app"
        # output_dir: "/app/build/aot_output/path/",
      ]
    ]
  end
end

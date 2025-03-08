defmodule CanClient.FfmpegStreamer do
  use GenServer
  require Logger

  # Configuration - modify these as needed
  @base_url "rtmp://desktop.local:9000/live/"
  @width 1280
  @height 720
  @framerate 30
  # 2 Mbps
  @bitrate "2M"
  # Default video device for Pi Camera
  @camera_device "/dev/video0"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init([uid]) do
    Logger.info("Starting Streamer RTMP streamer")

    # Ensure the camera module is loaded
    System.cmd("modprobe", ["bcm2835-v4l2"])

    send(self(), :start_streaming)

    {:ok,
     %{
       port: nil,
       session_uid: uid
     }}
  end

  def handle_info(:start_streaming, state) do
    {:noreply, %{state | port: start_streamer(state.session_uid)}}
  end

  def handle_info({port, {:exit_status, status}}, %{port: port} = state) do
    Logger.warn("Streamer exited with status: #{status}")
    {:stop, status}
  end

  def handle_info({port, {:data, data}}, %{port: port} = state) do
    # Log Streamer output (optional, can be verbose)
    Logger.info("Streamer output: #{inspect(data)}")
    {:noreply, state}
  end

  def terminate(reason, %{port: port}) do
    Logger.info("Ffmpeg exit with #{inspect(reason)}")

    if port do
      Port.close(port)
    end

    :ok
  end

  defp rtmp_url(session_uid) do
    @base_url <> session_uid
  end

  defp start_streamer(session_uid) do
    Logger.info("Starting RTMP stream to #{rtmp_url(session_uid)}")

    args = [
      "-t",
      "0",
      "-g",
      "10",
      "--bitrate",
      "4500000",
      "--inline",
      "--width",
      "1920",
      "--height",
      "1080",
      "--framerate",
      "30",
      "--rotation",
      "180",
      "--codec libav",
      "--libav-format",
      "flv",
      "--libav-audio",
      "--audio-bitrate",
      "192000",
      "--av-sync",
      "200000",
      "-n",
      "-o",
      rtmp_url(session_uid)
    ]

    Port.open({:spawn_executable, "/usr/bin/libcamera-vid"}, [
      :binary,
      :exit_status,
      :use_stdio,
      :stderr_to_stdout,
      {:args, args}
    ])
  end
end

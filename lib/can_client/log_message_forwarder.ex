defmodule CanClient.LogMessageForwarder do
  use GenServer
  alias CanClient.CitronAPI
  require Logger

  @max_buf_size 500
  @flush_interval 1_000
  @attempt_join_interval 1_000

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :timer.send_interval(@flush_interval, :flush)
    send(self(), :attempt_join)
    {:ok, {nil, []}}
  end

  def handle_info(:attempt_join, {nil, buf}) do
    if CitronAPI.is_connected?() do
      case CitronAPI.join("vehicle_logs:#{CanClient.Application.get_vehicle_id()}") do
        {:ok, _res, chan} ->
          Logger.info("Successfully joined the logger channel")
          {:noreply, {chan, buf}}
        {:error, {:already_joined, chan}} ->
          {:noreply, {chan, buf}}
      end
    else
      Logger.info("Can't join the logger, still not connected")
      :timer.send_after(@attempt_join_interval, :attempt_join)
      {:noreply, {nil, buf}}
    end
  end

  def handle_info(:flush, state = {nil, _}) do
    {:noreply, state}
  end
  def handle_info(:flush, {chan, buf}) do
    PhoenixClient.Channel.push_async(chan, "log", buf)
    {:noreply, {chan, []}}
  end

  def handle_cast({:forward, bundle}, {chan, buf}) do
    buf = Enum.take([bundle | buf], @max_buf_size)
    {:noreply, {chan, buf}}
  end

  def forward(bundle) do
    GenServer.cast(__MODULE__, {:forward, bundle})
  end
end

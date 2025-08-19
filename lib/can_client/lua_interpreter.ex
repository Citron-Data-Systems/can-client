defmodule CanClient.LuaInterpreter do
  use GenServer
  alias CanClient.LuaRunner
  require Logger

  defmodule API do
    use Lua.API
    alias CanClient.FrameHandler.WorldStateWriter.StateHolder

    deflua get_value(signal_name) do
      1
    end

    defp signal_loop(owner, callback) do
      receive do
        {StateHolder, k, v} ->
          send(owner, {:on_signal, k, v, callback})
      end

      signal_loop(owner, callback)
    end

    deflua on_signal(signal_name, callback) do
      owner = self()

      spawn_link(fn ->
        StateHolder.sub([signal_name])
        signal_loop(owner, callback)
      end)

      "ok"
    end

    deflua show_alert(message, options) do
      "TODO"
    end

    deflua on_tick(interval, callback) do
      send(self(), {:setup_timer, interval, callback})
      "ok"
    end
  end

  defmodule State do
    defstruct [:lua, :timers]
  end

  def start_link(), do: start_link([nil])

  def start_link([script]) do
    GenServer.start_link(__MODULE__, [script])
  end

  def init([script]) do
    lua = Lua.new() |> Lua.load_api(API)
    state = %State{lua: lua, timers: %{}}

    case script do
      nil ->
        {:ok, state}

      script ->
        LuaRunner.register(script)
        Logger.info("Starting script \n--\n#{script}\n--")
        {_res, state} = eval(script, state)
        {:ok, state}
    end
  end

  defp eval(prog, state) do
    {res, lua} = Lua.eval!(state.lua, prog)
    {res, %State{state | lua: lua}}
  end

  def handle_call({:run, prog}, _, state) do
    {res, state} = eval(prog, state)
    {:reply, res, state}
  end

  def handle_info({:setup_timer, interval, callback}, state) do
    :timer.send_interval(interval, {:tick, callback})
    {:noreply, state}
  end

  def handle_info({:on_signal, key, value, funref}, state) do
    {:ok, _, lua} = Lua.call_function(state.lua, funref, [key, value])
    {:noreply, %State{state | lua: lua}}
  end

  def handle_info({:tick, funref}, state) do
    {:ok, _, lua} = Lua.call_function(state.lua, funref, [])
    {:noreply, %State{state | lua: lua}}
  end

  def handle_cast(:shutdown, state) do
    {:stop, :normal, state}
  end

  def run(pid, prog) do
    GenServer.call(pid, {:run, prog})
  end

  def shutdown(pid) do
    GenServer.cast(pid, :shutdown)
  end
end

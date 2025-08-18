defmodule CanClient.LuaRunner do
  use GenServer
  alias CanClient.LuaInterpreter
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:register, script, pid}, state) do
    {:noreply, Map.put(state, script, pid)}
  end

  def handle_call(:shutdown_all, _, interpreters) do
    Enum.each(interpreters, fn _k, pid ->
      LuaInterpreter.shutdown(pid)
      Logger.info("Shutdown #{inspect(pid)}")
    end)
  end

  def handle_call({:whereis, script}, _, state) do
    {:reply, Map.get(state, script), state}
  end

  def handle_call({:spawn, script}, _, state) do
    {res, state} =
      with {:ok, pid} <-
             DynamicSupervisor.start_child(
               CanClient.LuaRunner.Supervisor,
               {LuaInterpreter, [script]}
             ) do
        Logger.info("Started script at #{inspect(pid)}")
        {:ok, state}
      else
        other -> {other, state}
      end

    {:reply, res, state}
  end

  def handle_call({:exit, script}, _, state) do
    {res, state} =
      case Map.pop(state, script) do
        {nil, state} ->
          {:noproc, state}

        {pid, state} ->
          LuaInterpreter.shutdown(pid)
          {:ok, state}
      end

    {:reply, res, state}
  end

  def handle_call({:run_in, script, expr}, _, state) do
    res =
      case Map.get(state, script) do
        nil ->
          :noproc

        pid ->
          LuaInterpreter.run(pid, expr)
      end

    {:reply, res, state}
  end

  def spawn(script) do
    GenServer.call(__MODULE__, {:spawn, script})
  end

  def whereis(script) do
    GenServer.call(__MODULE__, {:whereis, script})
  end

  def register(script) do
    GenServer.cast(__MODULE__, {:register, script, self()})
  end

  def run_in(script, expr) do
    GenServer.call(__MODULE__, {:run_in, script, expr})
  end

  def exit(script) do
    GenServer.call(__MODULE__, {:exit, script})
  end

  def shutdown_all() do
    GenServer.call(__MODULE__, :shutdown_all)
  end
end

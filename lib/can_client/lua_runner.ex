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

  defp shutdown_existing(state, name) do
    case Map.pop(state, name) do
      {nil, state} ->
        {:noproc, state}

      {pid, state} ->
        Logger.info("Shutting down #{name} @ #{inspect(pid)}")
        LuaInterpreter.shutdown(pid)
        {:ok, state}
    end
  end

  def handle_cast({:register, name, pid}, state) do
    Logger.info("Script #{name} has registered as pid #{inspect(pid)}")
    {:noreply, Map.put(state, name, pid)}
  end

  def handle_call(:shutdown_all, _, interpreters) do
    Enum.each(interpreters, fn k, pid ->
      Logger.info("Shutting down #{k}\n #{inspect(pid)}")
      LuaInterpreter.shutdown(pid)
    end)
  end

  def handle_call({:whereis, name}, _, state) do
    {:reply, Map.get(state, name), state}
  end

  def handle_call({:spawn, name, script}, _, state) do
    {_res, state} = shutdown_existing(state, name)

    Logger.info("Spawning script...")

    started =
      DynamicSupervisor.start_child(
        CanClient.LuaRunner.Supervisor,
        %{
          id: "script_#{name}",
          start: {LuaInterpreter, :start_link, [[name, script]]},
          max_restarts: 1000,
          max_seconds: 60,
          restart: :transient
        }
      )

    case started do
      {:ok, pid} ->
        Logger.info("Started #{name} @ #{inspect(pid)}")
        {:reply, :ok, state}

      other ->
        Logger.error("Failed to start script\n#{inspect(other)}")
        {:reply, other, state}
    end
  end

  def handle_call({:exit, name}, _, state) do
    {res, state} = shutdown_existing(state, name)
    {:reply, res, state}
  end

  def handle_call({:run_in, name, expr}, _, state) do
    res =
      case Map.get(state, name) do
        nil ->
          :noproc

        pid ->
          LuaInterpreter.run(pid, expr)
      end

    {:reply, res, state}
  end

  def spawn(name, script) do
    GenServer.call(__MODULE__, {:spawn, name, script})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whereis, name})
  end

  def register(name) do
    GenServer.cast(__MODULE__, {:register, name, self()})
  end

  def run_in(name, expr) do
    GenServer.call(__MODULE__, {:run_in, name, expr})
  end

  def exit(name) do
    GenServer.call(__MODULE__, {:exit, name})
  end

  def shutdown_all() do
    GenServer.call(__MODULE__, :shutdown_all)
  end
end

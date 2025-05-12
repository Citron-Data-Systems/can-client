defmodule CanClient.FrameWriter.WorldStateWriter do
  @behaviour CanClient.FrameHandler.FrameWriter

  defmodule DefinitionManager do
    alias CanClient.CitronAPI
    use GenServer
    require Logger

    defmodule State do
      defstruct [:dets_tab, :chan]
    end

    def start_link(_) do
      GenServer.start_link(__MODULE__, [])
    end

    defp dets_name(), do: :vehicle_defn
    @vehicle_definition :vehicle_def
    @dbc_definition :dbc_def

    def init(_) do
      send(self(), :connect)

      :ets.new(__MODULE__, [
        :set,
        :protected,
        :named_table,
        {:read_concurrency, true}
      ])

      {:ok, dets_tab} = :dets.open_file(dets_name(), type: :set, file: ~c"vehicle_dfn.dets")

      case :dets.lookup(dets_tab, @vehicle_definition) do
        [{_key, v_def}] ->
          load_def(v_def)
          Logger.info("Loaded existing vehicle defn from disk")

        _ ->
          Logger.info("No dets vehicle defn found, nothing to restore")
      end

      {:ok, %State{dets_tab: dets_tab}}
    end

    defp load_def(v_def) do
      true = :ets.insert(__MODULE__, {@vehicle_definition, v_def})

      lookup_table =
        Enum.flat_map(v_def["dbc_defs"], fn %{"content" => content} ->
          case Canbus.Dbc.parse(content) do
            {:ok, parsed} ->
              [parsed]

            error ->
              Logger.warning("Failed to load dbc #{inspect(error)}")
              []
          end
        end)
        |> Enum.each(fn parsed ->
          Enum.each(Map.keys(parsed.message), fn can_id ->
            :ets.insert(__MODULE__, {{@dbc_definition, can_id}, parsed})
          end)
        end)
    end

    defp save_def(dets_tab, v_def) do
      :dets.insert(dets_tab, {@vehicle_definition, v_def})
      load_def(v_def)
      Logger.info("Inserted new vehicle definition")
      :ok
    end

    def handle_info(:connect, state) do
      case CitronAPI.join("vehicle_meta:#{CanClient.Application.get_vehicle_id()}") do
        {:ok, _res, chan} ->
          send(self(), :check_updates)
          {:noreply, %State{state | chan: chan}}

        failure ->
          Logger.info("Failed to connect to vehicle metadata channel #{inspect(failure)}")
          :timer.send_after(5000, :connect)
          {:noreply, state}
      end
    end

    def handle_info(:check_updates, state) do
      case PhoenixClient.Channel.push(state.chan, "get", %{}) do
        {:ok, v_def} ->
          save_def(state.dets_tab, v_def)
          :ok
      end

      {:noreply, state}
    end

    def get_dbc(can_id) do
      case :ets.lookup(__MODULE__, {@dbc_definition, can_id}) do
        [{_, parsed}] ->
          {:ok, parsed}

        _ ->
          {:error, :not_found}
      end
    end

    def decode(id, bytes) do
      case get_dbc(id) do
        {:ok, dbc} ->
          try do
            Canbus.Decode.decode(dbc, {id, nil, bytes})
          rescue
            e ->
              Logger.error(Exception.format(:error, e, __STACKTRACE__))
              Logger.error("Failed to decode message #{id} #{inspect(e)}")
              nil
          end

        _ ->
          :ok
      end
    end
  end

  defmodule StateHolder do
    use GenServer

    def start_link() do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
      {:ok, %{}}
    end

    def handle_cast({:pub, kvs}, state) do
      IO.inspect {:pub, kvs}
      state = Enum.reduce(kvs, state, fn {k, v}, state -> Map.put(state, k, v) end)
      {:noreply, state}
    end

    def handle_call(:get, state) do
      {:reply, {:ok, state}, state}
    end

    def get() do
      GenServer.call(__MODULE__, :get)
    end

    def pub(kvs) do
      GenServer.cast(__MODULE__, {:pub, kvs})
    end
  end

  def init() do
    {:ok, _pid} =
      DynamicSupervisor.start_child(CanClient.DynamicSupervisor, {DefinitionManager, []})

    {:ok, _holder} = StateHolder.start_link()
    {:ok, %{}}
  end

  def handle_frames(frames, _state) do
    # IO.inspect {:handle_frames, frames}
    Enum.flat_map(frames, fn [id, _ts, bytes] ->
      case DefinitionManager.decode(id, bytes) do
        {:ok, kv_pairs} ->
          kv_pairs

        _ ->
          []
      end
    end)
    |> StateHolder.pub()
  end
end

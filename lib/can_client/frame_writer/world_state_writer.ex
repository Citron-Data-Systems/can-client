defmodule CanClient.FrameWriter.WorldStateWriter do
  @behaviour CanClient.FrameHandler.FrameWriter

  defmodule DefinitionManager do
    alias CanClient.FrameWriter.WorldStateWriter.StateHolder
    alias CanClient.CitronAPI
    use GenServer
    require Logger

    defmodule State do
      defstruct [:dets_tab]
    end

    def start_link(_) do
      GenServer.start_link(__MODULE__, [])
    end

    def emitter_topic(), do: "__vehicle_defn"

    defp dets_name(), do: :vehicle_defn
    @vehicle_definition :vehicle_def
    @dbc_definition :dbc_def

    def init(_) do
      connect(self())

      unless Enum.member?(:ets.all(), __MODULE__) do
        :ets.new(__MODULE__, [
          :set,
          :public,
          :named_table,
          {:read_concurrency, true}
        ])
      end

      file = Application.get_env(:can_client, :vehicle_meta_location)

      {:ok, dets_tab} = :dets.open_file(dets_name(), type: :set, file: String.to_charlist(file))

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
      StateHolder.pub([{emitter_topic(), v_def}])
      Logger.info("Inserted new vehicle definition")
      :ok
    end

    def handle_info({:save_def, v_def}, state) do
      save_def(state.dets_tab, v_def)
      {:noreply, state}
    end

    defp handle_updates(owner, chan) do
      receive do
        %PhoenixClient.Message{event: "update", payload: v_def} ->
          send(owner, {:save_def, v_def})
          handle_updates(owner, chan)
      end
    end

    defp on_join_channel(owner, chan) do
      Logger.info("Successfully connected to vehicle metadata channel, asking for vehicle def")

      case PhoenixClient.Channel.push(chan, "get", %{}) do
        {:ok, v_def} ->
          send(owner, {:save_def, v_def})
          :ok
      end

      handle_updates(owner, chan)
    end

    def connect(owner) do
      spawn(fn ->
        case CitronAPI.join("vehicle_meta:#{CanClient.Application.get_vehicle_id()}") do
          # TODO: subscripe for realtime updates here
          {:ok, _res, chan} ->
            on_join_channel(owner, chan)

          {:error, {:already_joined, chan}} ->
            on_join_channel(owner, chan)

          failure ->
            Logger.info("Failed to connect to vehicle metadata channel #{inspect(failure)}")
            Process.sleep(5000)
            connect(owner)
        end
      end)

      :ok
    end

    defp not_found_or_disconnected() do
      if CitronAPI.is_connected?() do
        {:error, :not_found}
      else
        {:error, :offline}
      end
    end

    def get_vehicle() do
      case :ets.lookup(__MODULE__, @vehicle_definition) do
        [{@vehicle_definition, v_def}] ->
          {:ok, v_def}

        _ ->
          Logger.warning("No vehicle found, defaulting to simple dash")
          not_found_or_disconnected()
      end
    end

    def get_dbc(can_id) do
      case :ets.lookup(__MODULE__, {@dbc_definition, can_id}) do
        [{_, parsed}] ->
          {:ok, parsed}

        _ ->
          not_found_or_disconnected()
      end
    end

    def decode(id, bytes) do
      try do
        case get_dbc(id) do
          {:ok, dbc} ->
            Canbus.Decode.decode(dbc, {id, nil, bytes})

          _ ->
            :ok
        end
      rescue
        e ->
          Logger.error(Exception.format(:error, e, __STACKTRACE__))
          Logger.error("Failed to decode message #{id} #{inspect(e)}")
          nil
      end
    end
  end

  defmodule StateHolder do
    require Logger
    use GenServer

    def start_link(_) do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
      Logger.info("World state holder is up")
      {:ok, {%{}, %{}}}
    end

    def handle_cast({:pub, kvs}, {ws, subscriptions}) do
      ws = Enum.reduce(kvs, ws, fn {k, v}, state -> Map.put(state, k, v) end)

      Enum.each(kvs, fn {k, v} ->
        Map.get(subscriptions, k, [])
        |> Enum.each(fn pid ->
          send(pid, {__MODULE__, k, v})
        end)
      end)

      {:noreply, {ws, subscriptions}}
    end

    def handle_cast({:sub, topics, who}, {ws, subscriptions}) do
      _ref = Process.monitor(who)

      subscriptions =
        Enum.reduce(topics, subscriptions, fn topic, acc ->
          existing = Map.get(acc, topic, [])
          Map.put(acc, topic, Enum.uniq([who | existing]))
        end)

      {:noreply, {ws, subscriptions}}
    end

    def handle_call(:get, {ws, _} = state) do
      {:reply, {:ok, ws}, state}
    end

    def handle_info({:DOWN, _ref, :process, pid, _reason}, {ws, subscriptions}) do
      subscriptions =
        Enum.map(subscriptions, fn {signal, subs} ->
          {signal, List.delete(subs, pid)}
        end)
        |> Enum.into(%{})

      {:noreply, {ws, subscriptions}}
    end

    def get() do
      GenServer.call(__MODULE__, :get)
    end

    defp resubscribe_forever(topics, subscriber) do
      publisher = Process.whereis(__MODULE__)

      ref = Process.monitor(publisher)
      GenServer.cast(publisher, {:sub, topics, subscriber})

      receive do
        {:DOWN, ^ref, :process, _pid, reason} ->
          Logger.warning(
            "Process #{inspect(publisher)} exited with #{inspect(reason)}, resubscribing"
          )

          # hmm
          Process.sleep(100)

          resub = Process.whereis(__MODULE__)
          Logger.info("Resubscribing now to #{inspect(resub)}")
          resubscribe_forever(topics, subscriber)
      end
    end

    def sub(topics) do
      subscriber = self()

      spawn_link(fn ->
        resubscribe_forever(topics, subscriber)
      end)
    end

    def pub(kvs) do
      GenServer.cast(__MODULE__, {:pub, kvs})
    end
  end

  def init() do
    {:ok, %{}}
  end

  def handle_frames(frames, _state) do
    Enum.flat_map(frames, fn [id, _ts, bytes] ->
      case DefinitionManager.decode(id, bytes) do
        {:ok, kv_pairs} ->
          kv_pairs

        e ->
          []
      end
    end)
    |> StateHolder.pub()
  end
end

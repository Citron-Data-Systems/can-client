defmodule CanClient.FrameHandler.WorldStateWriter do
  alias CanClient.FrameHandler.VehicleMetaChannel
  @behaviour CanClient.FrameHandler.FrameHandler



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

    def handle_call({:get, signal}, _from, {ws, _} = state) do
      {:reply, {:ok, Map.get(ws, signal)}, state}
    end

    def handle_info({:DOWN, _ref, :process, pid, _reason}, {ws, subscriptions}) do
      subscriptions =
        Enum.map(subscriptions, fn {signal, subs} ->
          {signal, List.delete(subs, pid)}
        end)
        |> Enum.into(%{})

      {:noreply, {ws, subscriptions}}
    end

    def get(signal) do
      GenServer.call(__MODULE__, {:get, signal})
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
      case VehicleMetaChannel.decode(id, bytes) do
        {:ok, kv_pairs} ->
          kv_pairs

        e ->
          []
      end
    end)
    |> StateHolder.pub()
  end
end

defmodule CanClient.IEXTools do
  def muon_traps() do
    :erlang.processes()
    |> Enum.map(fn p -> {p, Process.info(p)[:current_function]} end)
    |> Enum.filter(fn
      {_, {:gen_server, _, _}} -> true
      _ -> false
    end)
    |> Enum.map(fn {p, _} -> {p, :sys.get_state(p)} end)
    |> Enum.filter(fn {_, s} ->
      case s do
        %MuonTrap.Daemon{} -> true
        _ -> false
      end
    end)
  end


  def topk(k \\ 10) do
    :erlang.processes()
    |> Enum.map(fn p -> {p, Process.info(p)} end)
    |> Enum.sort_by(fn {_p, i} -> i[:message_queue_len] end, :desc)
    |> Enum.take(k)
  end
end

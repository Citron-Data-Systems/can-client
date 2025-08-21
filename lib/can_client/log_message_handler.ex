defmodule CanClient.LogMessageHandler do
  alias CanClient.LogMessageForwarder
  # Client API
  def attach do
    :ok = :logger.add_handler(:log_forwarder, __MODULE__, %{})
  end

  def detach do
    :logger.remove_handler(:log_forwarder)
  end

  # gen_event callbacks
  def init(config) do
    {:ok, config}
  end

  def log(event, _config) do
    message = Logger.Formatter.format_event(event, 2048)
    {m, f, a} = event.meta.mfa

    bundle = %{
      meta:
        event.meta
        |> Map.take([:line, :time])
        |> Map.put(:mfa, %{m: m, f: f, a: a})
        |> Map.put(:pid, inspect(event.meta.pid))
        |> Map.put(:level, event.level)
        |> Map.put(:file, to_string(event.meta.file)),
      message: message
    }

    LogMessageForwarder.forward(bundle)

    :ok
  end
end

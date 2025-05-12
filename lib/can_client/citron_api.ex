defmodule CanClient.CitronAPI do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    send(self(), :connect)
    {:ok, nil}
  end

  defp await_connected(_socket, max_attempts, max_attempts) do
    {:error, "Failed to connect to phx channel after #{max_attempts} tries"}
  end

  defp await_connected(socket, attempts, max_attempts) do
    if not PhoenixClient.Socket.connected?(socket) do
      Process.sleep(500 * attempts)
      Logger.info("Await connection attempt #{attempts}/#{max_attempts}")
      await_connected(socket, attempts + 1, max_attempts)
    else
      Logger.info("Connected to phx socket")
      IO.inspect(socket)
      {:ok, socket}
    end
  end

  def connect() do
    socket_opts = [
      url: Application.get_env(:can_client, :ws_url)
    ]

    Logger.info("Connecting to socket #{inspect(socket_opts)}")

    with {:ok, socket} <- PhoenixClient.Socket.start_link(socket_opts) do
      await_connected(socket, 0, 3)
    end
  end

  def handle_info(:connect, _socket) do
    case connect() do
      {:ok, socket} ->
        {:noreply, socket}

      {:error, reason} ->
        Logger.warning("Failed to connect to the citron websocket #{reason}")
        {:stop, reason}
    end
  end

  def handle_call(:get, _from, nil) do
    {:reply, {:error, :disconnected}, nil}
  end

  def handle_call(:get, _from, socket) do
    {:reply, {:ok, socket}, socket}
  end

  def join(topic) do
    with {:ok, socket} <- GenServer.call(__MODULE__, :get) do
      Logger.info("Joining #{topic}")
      PhoenixClient.Channel.join(socket, topic)
    end
  end
end

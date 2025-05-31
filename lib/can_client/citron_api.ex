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

  defp connect() do
    socket_opts = [
      url: Application.get_env(:can_client, :ws_url)
    ]

    Logger.info("Connecting to socket #{inspect(socket_opts)}")

    PhoenixClient.Socket.start_link(socket_opts)
  end

  def handle_info(:connect, _socket) do
    {:ok, socket} = connect()
    {:noreply, socket}
  end

  def handle_call(:get, _from, nil) do
    {:reply, {:error, :offline}, nil}
  end

  def handle_call(:get, _from, socket) do
    if not PhoenixClient.Socket.connected?(socket) do
      {:reply, {:error, :offline}, socket}
    else
      {:reply, {:ok, socket}, socket}
    end
  end

  def handle_call(:is_connected, _from, socket) do
    {:reply, PhoenixClient.Socket.connected?(socket), socket}
  end

  def join(topic) do
    with {:ok, socket} <- GenServer.call(__MODULE__, :get) do
      Logger.info("Joining #{topic}")
      PhoenixClient.Channel.join(socket, topic)
    end
  end

  def is_connected?() do
    GenServer.call(__MODULE__, :is_connected)
  end
end

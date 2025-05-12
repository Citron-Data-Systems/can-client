defmodule CanClient.CanNet do
  use GenServer
  require Logger
  @port 29536

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    res =
      VintageNet.configure("can0", %{
        type: VintageNetCan,
        can: %{bitrate: 500_000},
        socket: %{
          port: @port,
          can_interfaces: ["can0"],
          linked_interface: "lo"
        }
      })

    {:ok, res}
  end

  def open_socket() do
    with {:ok, socket} <- Cand.Socket.start_link(),
         :hi = Cand.Socket.connect(socket, {127, 0, 0, 1}, @port),
         [:ok] = Cand.Protocol.open(socket, "can0") do
      Cand.Protocol.raw_mode(socket)
      Logger.info("CAN Connection up at #{inspect(socket)}")
      {:ok, socket}
    end
  end
end

# CanClient
Uses an MCP2515 to read can messages, does stuff with them


## TODO
* figure out grpc and streaming
  * figure out how to run it in host mode without the nerves device at all
* hook up grpc to can read
* 

## Notes

### Tx/rx counters
{res, _} = System.cmd("ip", ["-details", "link", "show", "can0"]); IO.puts(res)
### dump
cmd("candump can0")



### This should work
port = 29536
VintageNet.configure("can0", %{
    type: VintageNetCan,
    can: %{bitrate: 500_000},
    socket: %{
      port: port,
      can_interfaces: ["can0"],
      linked_interface: "lo",
    }
  })

Process.sleep(1_000)

{:ok, socket} = Cand.Socket.start_link()
Cand.Socket.connect(socket, {127,0,0,1}, port)
Process.sleep(500)
Cand.Protocol.open(socket, "can0")
Cand.Protocol.raw_mode(socket)
Cand.Protocol.receive_frame(socket)


# Setup
* install flutter
* install protocol buffers
* install dart protobufs
```
dart pub global activate protoc_plugin
```
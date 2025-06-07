# CanClient
Uses an MCP2515 to read can messages, does stuff with them


## TODO

* fix labels on linear gauge dart component
* fix tick marks on circular gauge dart component
* status component
  * for fan state or

### BUGS
* disconnect and reconnect doesn't restart the definition manager process
* doesn't restart the phx writer process

## Notes



### Tx/rx counters
{res, _} = System.cmd("ip", ["-details", "link", "show", "can0"]); IO.puts(res)
### dump
cmd("candump can0")

### API
#### To add/update an API call
* edit priv/proto/rpc_schema.proto
* run ./proto-gen.sh
* edit server.ex to do stuff
* rpc_schema.pb.ex is a generated file

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
`sudo apt-get install -y protobuf-compiler unzip xz-utils zip libglu1-mesa clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev`
* install protocol buffers
* install dart protobufs
```
dart pub global activate protoc_plugin 21.1.2
```

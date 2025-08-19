defmodule LuaInterpreterTest do
  use ExUnit.Case
  alias CanClient.{LuaRunner, LuaInterpreter}
  alias CanClient.FrameHandler.WorldStateWriter.StateHolder
  import TestHelpers

  test "can run something" do
    {:ok, pid} = LuaInterpreter.start_link()

    res =
      LuaInterpreter.run(pid, """
        x = 1
        return x + 1
      """)

    assert res == [2]
  end

  defp await_x_loop(owner, pid, condition) do
    [res] = LuaInterpreter.run(pid, "return x")

    if condition.(res) do
      send(owner, :done)
    else
      :timer.sleep(1)
      await_x_loop(owner, pid, condition)
    end
  end

  defp await_x(pid, condition) do
    me = self()
    spawn(fn -> await_x_loop(me, pid, condition) end)

    receive do
      :done -> :ok
    end
  end

  test "can tick" do
    {:ok, pid} = LuaInterpreter.start_link()

    LuaInterpreter.run(pid, """

    x = 0
    function doit()
      x = x + 1
    end

    on_tick(1, doit)
    """)

    await_x(pid, fn x -> x > 10 end)
  end

  test "can get a signal" do
    {:ok, pid} = LuaInterpreter.start_link()

    LuaInterpreter.run(pid, """

    x = 0
    function doit(k, v)
      x = v
    end

    on_signal("foo", doit)
    """)

    # there's a race here where if the subscribe doesn't happen fast enough
    :timer.sleep(100)

    StateHolder.pub([
      {"foo", 1},
      {"foo", 2}
    ])

    StateHolder.pub([
      {"foo", 10},
      {"foo", 12}
    ])

    await_x(pid, fn x -> x > 10 end)
  end

  describe "runner" do
    test "lua threads are supervised" do
      script = """
      x = 0
      function doit(k, v)
        x = v
      end

      on_signal("foo", doit)
      """

      name = "mycoolscript.lua"

      :ok =
        LuaRunner.spawn(name, script)

      StateHolder.pub([
        {"foo", 1},
        {"foo", 2}
      ])

      og_pid = LuaRunner.whereis(name)
      await_x(og_pid, fn x -> x == 2 end)

      LuaRunner.whereis(name) |> Process.exit(:die)

      await(fn -> og_pid != LuaRunner.whereis(name) end, 1000)

      new_pid = LuaRunner.whereis(name)
      await_x(new_pid, fn x -> x == 0 end)
    end
  end
end

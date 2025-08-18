ExUnit.start()

defmodule TestHelpers do
  def await(_fun, time) when time < 0 do
    raise RuntimeError, message: "timeout"
  end
  def await(fun, time) do
    s = 50
    res = fun.()
    if res do
      res
    else
      Process.sleep(s)
      await(fun, time - s)
    end
  end
end

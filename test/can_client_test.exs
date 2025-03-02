defmodule CanClientTest do
  use ExUnit.Case
  doctest CanClient

  test "greets the world" do
    assert CanClient.hello() == :world
  end
end

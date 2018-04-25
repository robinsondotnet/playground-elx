defmodule ServiceSheriffTest do
  use ExUnit.Case
  doctest ServiceSheriff

  test "greets the world" do
    assert ServiceSheriff.hello() == :world
  end
end

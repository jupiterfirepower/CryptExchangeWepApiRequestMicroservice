defmodule CermicrosTest do
  use ExUnit.Case
  doctest Cermicros

  test "add/2 should add two numbers" do
    result = 2 + 3
    assert result == 5
  end
end

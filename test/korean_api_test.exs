defmodule KoreanApiTest do
  use ExUnit.Case
  doctest KoreanApi

  test "greets the world" do
    assert KoreanApi.hello() == :world
  end
end

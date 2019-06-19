defmodule KoreanApi.Models.Role do
  @moduledoc """
  The base word
  """
  use Ecto.Schema

  schema "auth.roles" do
    field(:role, :string)
  end
end

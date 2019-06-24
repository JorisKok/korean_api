defmodule KoreanApi.Models.User do
  @moduledoc """
  The base word
  """
  use Ecto.Schema
  alias KoreanApi.Models.Role

  schema "auth.users" do
    field(:email, :string)
    field(:password, :string)
    belongs_to(:role, Role)
  end
end

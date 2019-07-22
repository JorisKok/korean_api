defmodule KoreanApi.Repos.WordRepo do
  @moduledoc """
  The Korean word repo
  """
  alias KoreanApi.Repo
  alias KoreanApi.Models.Word

  def get_by_korean!(korean) do
    Repo.get_by!(Word, korean: korean)
  end
end

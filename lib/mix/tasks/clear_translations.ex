defmodule Mix.Tasks.ClearTranslations do
  @moduledoc """
  Clear the translations from the database
  Useful for local testing
  """
  use Mix.Task

  @shortdoc "Clear the translations"
  def run(_) do
    [:postgrex, :ecto, :ecto_sql]
    |> Enum.each(&Application.ensure_all_started/1)

    KoreanApi.Repo.start_link()

    queries = [
      "truncate flashcards;",
      "truncate words cascade;"
    ]

    Enum.each(queries, fn query ->
      try do
        Ecto.Adapters.SQL.query(KoreanApi.Repo, query)
      rescue
        # This still errors
        _ -> IO.puts("Already executed")
      end
    end)
  end
end

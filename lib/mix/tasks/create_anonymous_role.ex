defmodule Mix.Tasks.CreateAnonymousRole do
  @moduledoc """
  Create the anonymous roles and gives it rights
  """
  use Mix.Task

  @shortdoc "Create the database roles"
  def run(_) do
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)

    KoreanApi.Repo.start_link()

    queries = [
      "create role web_anon nologin;",
      "grant usage on schema public to web_anon;",
      "grant select on words to web_anon;",
      "grant select on word_definitions to web_anon;",
      "grant select on word_translations to web_anon;",
    ]

    Enum.each(queries, fn query ->
      try do
        Ecto.Adapters.SQL.query(KoreanApi.Repo, query)

      rescue
        _ -> IO.puts "Already executed" # This still errors
      end
    end)

  end
end

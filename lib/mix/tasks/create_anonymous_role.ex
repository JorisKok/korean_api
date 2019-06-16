defmodule Mix.Tasks.CreateAnonymousRole do
  @moduledoc """
  Create the anonymous roles and gives it rights
  """
  use Mix.Task

  @shortdoc "Create the anonymous role"
  def run(_) do
    [:postgrex, :ecto, :ecto_sql]
    |> Enum.each(&Application.ensure_all_started/1)

    KoreanApi.Repo.start_link()

    queries = [
      "create role web_anon nologin;",
      "grant usage on schema public to web_anon;",
      "grant select on words to web_anon;",
      "grant select on word_translations to web_anon;",
      "grant select on word_example_sentences to web_anon;",
      "grant select on word_korean_explanations to web_anon;"
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

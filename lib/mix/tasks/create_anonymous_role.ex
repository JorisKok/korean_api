defmodule Mix.Tasks.CreateAnonymousRole do
  use Mix.Task

  @shortdoc "Create the database roles"
  def run(_) do
    [:postgrex, :ecto]
      |> Enum.each(&Application.ensure_all_started/1)
    KoreanApi.Repo.start_link

#    query = """
#      create role web_anon nologin;
#    """
#
#    Ecto.Adapters.SQL.query!(KoreanApi.Repo, query)
#
#    query = """
#      grant usage on schema public to web_anon;
#    """
#
#    Ecto.Adapters.SQL.query!(KoreanApi.Repo, query)

    query = """
      grant select on words to web_anon;
    """

    Ecto.Adapters.SQL.query(KoreanApi.Repo, query)
  end
end
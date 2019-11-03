defmodule KoreanApi.Repo.Migrations.CreateAnonymousRole do
  use Ecto.Migration

  def change do
    execute("create schema auth;")
    execute("drop role if exists web_anon;")
    execute("drop role if exists web_user;")
    execute("drop role if exists authenticator;")
    execute("create role web_anon nologin;")
    execute("create role web_user nologin;")
    execute("create role authenticator noinherit login password '#{Application.fetch_env!(:korean_api, :authenticator_secret)}';")
    execute("grant web_anon to authenticator;")
    execute("grant web_user to authenticator;")
    execute("grant usage on schema auth to web_anon, web_user;")
    # Security
    execute("revoke create on schema public, auth from web_anon;")
  end
end

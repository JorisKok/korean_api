defmodule KoreanApi.Repo.Migrations.CreateAnonymousRole do
  use Ecto.Migration

  def change do
    execute("create schema auth;")
    execute("drop role if exists web_anon;")
    execute("create role web_anon nologin;")
    execute("grant web_anon to authenticator;")
    execute("grant usage on schema auth to web_anon;")
    # Security
    execute("revoke create on schema public, auth from web_anon;")
  end
end

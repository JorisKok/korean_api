defmodule KoreanApi.Repo.Migrations.CreateWebUserRole do
  use Ecto.Migration

  def up do
    execute("drop role if exists web_user;")
    execute("create role web_user nologin;")
    execute("grant web_user to authenticator;")
  end

  def down do
    execute("drop role if exists web_user;")
  end
end

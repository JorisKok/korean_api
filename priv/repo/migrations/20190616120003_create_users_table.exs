defmodule KoreanApi.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :email, :string
      add :password, :string
    end

    execute("create extension pgcrypto;")
    execute(
      """
      CREATE OR REPLACE FUNCTION set_password() RETURNS trigger AS $$
      BEGIN
          IF tg_op = 'INSERT' OR tg_op = 'UPDATE' THEN
              NEW.password = digest(NEW.password, 'sha256');
              RETURN NEW;
          END IF;
      END;
      $$ LANGUAGE plpgsql;
      """
    )
    execute(
      """
      CREATE TRIGGER user_password_insert
      BEFORE INSERT ON users
      FOR EACH ROW
      EXECUTE PROCEDURE set_password();
      """
    )
    execute(
      """
      CREATE TRIGGER user_password_update
      BEFORE UPDATE ON users
      FOR EACH ROW
      WHEN ( NEW.password IS DISTINCT FROM OLD.password )
      EXECUTE PROCEDURE set_password();
      """
    )
  end

  def down do
    drop table(:users)
    execute("DROP FUNCTION set_password;")
  end
end

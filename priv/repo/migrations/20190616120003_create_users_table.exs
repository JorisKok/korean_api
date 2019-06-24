defmodule KoreanApi.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table(:users, prefix: "auth") do
      add :email, :string
      add :password, :string
    end

    create table(:tokens, prefix: "auth") do
      add :user_id, references(:users)
      add :token, :string
    end

    create unique_index(:users, [:email], prefix: "auth")

    execute("CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA auth;")
    execute("CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA auth;")
    execute("revoke all on all functions in schema auth from web_anon;")

    execute(
      """
      CREATE OR REPLACE FUNCTION auth.set_password() RETURNS trigger AS $$
      BEGIN
          IF tg_op = 'INSERT' OR tg_op = 'UPDATE' THEN
              NEW.password = auth.crypt(new.password, auth.gen_salt('bf'));
              RETURN NEW;
          END IF;
      END;
      $$ LANGUAGE plpgsql;
      """
    )

    execute(
      """
      CREATE TRIGGER user_password_insert
      BEFORE INSERT ON auth.users
      FOR EACH ROW
      EXECUTE PROCEDURE auth.set_password();
      """
    )

    execute(
      """
      CREATE TRIGGER user_password_update
      BEFORE UPDATE ON auth.users
      FOR EACH ROW
      WHEN ( NEW.password IS DISTINCT FROM OLD.password )
      EXECUTE PROCEDURE auth.set_password();
      """
    )

    execute("ALTER FUNCTION auth.set_password() SET search_path = auth;")

  end

  def down do
    drop table(:users, prefix: "auth")
    drop table(:tokens, prefix: "auth")
    execute("DROP FUNCTION auth.set_password;")

  end
end

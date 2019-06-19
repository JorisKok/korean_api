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

    execute("CREATE EXTENSION IF NOT EXISTS pgcrypto;")
    execute("CREATE EXTENSION IF NOT EXISTS pgjwt;")
    execute("alter extension pgcrypto set schema auth;")

    execute(
      """
      CREATE OR REPLACE FUNCTION set_password() RETURNS trigger AS $$
      BEGIN
          IF tg_op = 'INSERT' OR tg_op = 'UPDATE' THEN
              NEW.password = crypt(new.password, gen_salt('bf'));
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
      EXECUTE PROCEDURE set_password();
      """
    )

    execute(
      """
      CREATE TRIGGER user_password_update
      BEFORE UPDATE ON auth.users
      FOR EACH ROW
      WHEN ( NEW.password IS DISTINCT FROM OLD.password )
      EXECUTE PROCEDURE set_password();
      """
    )

  end

  def down do
    drop table(:users, prefix: "auth")
    drop table(:tokens, prefix: "auth")
    execute("DROP FUNCTION auth.set_password;")

  end
end

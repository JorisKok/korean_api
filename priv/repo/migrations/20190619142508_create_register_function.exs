defmodule KoreanApi.Repo.Migrations.CreateRegisterFunction do
  use Ecto.Migration

  def up do

    execute(
      """
      CREATE OR REPLACE FUNCTION auth.register(email text, password text) RETURNS text AS $$
      DECLARE
        _id integer;
        result text;
      BEGIN
      INSERT INTO auth.users (email, password) VALUES (email, password) RETURNING id INTO _id;
      if _id is null then
        raise invalid_password using message = 'email already exists';
      end if;

      SELECT sign(row_to_json(r), '#{Application.fetch_env!(:korean_api, :jwt_secret)}') as token FROM (select email, extract(epoch from now())::integer +60*60 as exp) r INTO result;

      RETURN result;
      END;

      $$ LANGUAGE plpgsql;
      """
    )

    execute("ALTER FUNCTION auth.register(text, text) SET search_path = auth,public;")
  end

  def down do
    execute("DROP FUNCTION auth.register;")
  end
end

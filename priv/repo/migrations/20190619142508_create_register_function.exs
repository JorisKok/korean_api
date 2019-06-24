defmodule KoreanApi.Repo.Migrations.CreateRegisterFunction do
  use Ecto.Migration

  def up do
    execute(
      """
      CREATE OR REPLACE FUNCTION public.register(email text, password text) RETURNS text AS $$
      DECLARE
        _id integer;
        result text;
      BEGIN
      INSERT INTO auth.users (email, password) VALUES (email, password) RETURNING id INTO _id;
      if _id is null then
        raise invalid_password using message = 'email already exists';
      end if;

      SELECT auth.sign(row_to_json(r), '#{
        Application.fetch_env!(:korean_api, :jwt_secret)
      }') as token FROM (select 'web_user' as role, email, extract(epoch from now())::integer +60*60 as exp) r INTO result;

      RETURN result;
      END;

      $$ LANGUAGE plpgsql;
      """
    )

    execute("ALTER FUNCTION public.register(text, text) SET search_path = auth;")
    execute("grant execute on function public.register(text,text) to web_anon;")
    execute("grant select on auth.users to web_anon;")
    execute("grant insert on auth.users to web_anon;")
    execute("GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA auth TO web_anon;")
  end

  def down do
    execute("DROP FUNCTION auth.register;")
  end
end

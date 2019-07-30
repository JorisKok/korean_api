defmodule KoreanApi.Repo.Migrations.CreateLoginFunction do
  use Ecto.Migration

  def up do

    execute(
      """
      CREATE OR REPLACE FUNCTION public.login(email text, password text) RETURNS text AS $$
      DECLARE
        result text;
        _email text;
      BEGIN
      SELECT auth.users.email INTO _email FROM auth.users WHERE auth.users.email = $1 and auth.users.password = auth.crypt($2, auth.users.password);
      if _email is null then
        raise invalid_password using message = 'invalid user or password';
      end if;

      SELECT auth.sign(row_to_json(r), '#{Application.fetch_env!(:korean_api, :jwt_secret)}') as token FROM (select 'web_user' as role, _email as email, extract(epoch from now())::integer +60*60 as exp) r INTO result;

      RETURN result;
      END;

      $$ LANGUAGE plpgsql;
      """
    )


    execute("ALTER FUNCTION public.login(text, text) SET search_path = public")
    execute("grant execute on function public.login(text,text) to web_anon;")
  end

  def down do
    execute("DROP FUNCTION public.login;")
  end
end

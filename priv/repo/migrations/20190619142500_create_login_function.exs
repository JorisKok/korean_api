defmodule KoreanApi.Repo.Migrations.CreateLoginFunction do
  use Ecto.Migration

  def up do
    execute(
      """
      CREATE OR REPLACE FUNCTION public.login(email text, password text) RETURNS text AS $$
      DECLARE result text;
      BEGIN
      SELECT id INTO result FROM auth.users WHERE auth.users.email = $1 and auth.users.password = crypt($2, auth.users.password);
      RETURN result;
      END;

      $$ LANGUAGE plpgsql;
      """
    )

    execute("ALTER FUNCTION public.login(text, text) SET search_path = auth,public;")

    execute("REVOKE EXECUTE ON FUNCTION public.login(text, text) FROM web_anon;")
  end

  def down do
    execute("DROP FUNCTION public.login;")
  end
end

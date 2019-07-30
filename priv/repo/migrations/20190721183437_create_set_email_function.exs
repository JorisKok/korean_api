defmodule KoreanApi.Repo.Migrations.CreateSetEmailFunction do
  use Ecto.Migration
  
  def up do
  
    execute ("
      CREATE OR REPLACE FUNCTION public.get_email(jwt text)
      RETURNS text AS
      $$
      DECLARE
        email text;
      BEGIN
      RETURN select payload::json->'email' as email from auth.verify(jwt', '#{Application.fetch_env!(:korean_api, :jwt_secret)}') where valid is true;
      END
      $$ LANGUAGE 'plpgsql'
    ")
    
    execute "
      CREATE OR REPLACE FUNCTION public.set_email()
      RETURNS trigger AS
      $$
      BEGIN
      NEW.email = public.get_email(NEW.email);
      RETURN NEW;
      END
      $$ LANGUAGE 'plpgsql'
    "

    execute("ALTER FUNCTION public.set_email() SET search_path = public,auth")
    execute("ALTER FUNCTION public.get_email() SET search_path = public,auth")
    execute("grant execute on function public.set_email() to web_user;")
    execute("grant execute on function public.get_email() to web_user;")
  end
  
  def down do
    execute("DROP FUNCTION public.set_user;")
  
  end
end

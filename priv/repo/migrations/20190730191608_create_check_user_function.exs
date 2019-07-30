defmodule KoreanApi.Repo.Migrations.CreateCheckUserFunction do
  use Ecto.Migration
  
  def up do
    
    execute(
      "CREATE OR REPLACE FUNCTION public.check_user()
      RETURNS TEXT AS $$
      BEGIN
      RETURN current_user;
      END;
      $$ LANGUAGE plpgsql;
      "
    )

    execute("grant execute on function public.check_user() to web_user;")
  end
  
  def down do
    execute("drop function check_user")
  end
end

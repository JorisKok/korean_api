defmodule KoreanApi.Repo.Migrations.CreateGetProgressFunction do
  use Ecto.Migration

  def up do
    execute("
    CREATE OR REPLACE FUNCTION public.get_progress(_level text, _topic text)
      RETURNS INT AS $$
      DECLARE
        progress INT;
      BEGIN
        SELECT ((COUNT(*) * 10) - SUM(difficulty)) / GREATEST(1, ((COUNT(*) * 10) / 100)) as progress
        FROM learn
        WHERE  level = _level
        AND topic = _topic
        AND email = public.get_email()
        into progress;
        RETURN progress;
      END;
      $$ LANGUAGE plpgsql;
      "
    )
  
    execute("grant execute on function public.get_progress(text, text) to web_user;")
  end

  def down do
    execute("drop function public.get_progress(text, text);")
  end
end

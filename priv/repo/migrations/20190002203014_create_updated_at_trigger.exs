defmodule KoreanApi.Repo.Migrations.CreateUpdatedAtTrigger do
  use Ecto.Migration

  def up do
    execute("
    CREATE OR REPLACE FUNCTION trigger_set_timestamp()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ")
  end
end

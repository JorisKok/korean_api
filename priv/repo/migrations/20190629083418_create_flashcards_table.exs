defmodule KoreanApi.Repo.Migrations.CreateFlashcardsTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration
  
  def up do
    create table(:flashcards) do
      add :word_id, references(:words), null: false
      add :token, :string, null: false
    end
    
    execute("grant select, insert on flashcards to web_anon;")
    execute("grant usage, select on all sequences in schema public to web_anon;")
    
    create index(:flashcards, [:token])
    
    execute("
    CREATE OR REPLACE FUNCTION trigger_delete_after_a_week()
    RETURNS TRIGGER AS $$
    BEGIN
      DELETE FROM flashcards WHERE updated_at < current_date - 1;
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    ")

    add_timestamps("flashcards")
  end
  
  def down do
    drop table(:flashcards)
  end
end

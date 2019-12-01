defmodule KoreanApi.Repo.Migrations.CreateFlashcardWords do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration
  
  def up do
    create table(:flashcard_words) do
      add :word_id, references(:words, on_delete: :delete_all), null: false
      add :word_translation_id, references(:word_translations, on_delete: :delete_all), null: false
      add :token, :string, null: false
    end
  
    execute("grant select, insert, delete on flashcard_words to web_anon;")
    execute("grant usage, select on all sequences in schema public to web_anon;")
  
    create index(:flashcard_words, [:token])
    create unique_index(:flashcard_words, [:word_translation_id, :token])
  
    execute(
      "
    CREATE OR REPLACE FUNCTION trigger_delete_flashcard_words_after_a_week()
    RETURNS TRIGGER AS $$
    BEGIN
      DELETE FROM flashcard_words WHERE updated_at < current_date - 1;
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    "
    )
  
    add_timestamps("flashcard_words")
  end

  def down do
    drop table(:flashcard_words)
  end
end

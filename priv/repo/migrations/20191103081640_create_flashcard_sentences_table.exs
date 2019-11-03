defmodule KoreanApi.Repo.Migrations.CreateFlashcardSentencesTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration

  def up do
    create table(:flashcard_sentences) do
      add :word_id, references(:words, on_delete: :delete_all), null: false
      add :word_example_sentence_id, references(:word_example_sentences, on_delete: :delete_all), null: false
      add :token, :string, null: false
    end
  
    execute("grant select, insert, delete on flashcard_sentences to web_anon;")
    execute("grant usage, select on all sequences in schema public to web_anon;")
  
    create index(:flashcard_sentences, [:token])
    create unique_index(:flashcard_sentences, [:word_example_sentence_id, :token])
  
    execute(
      "
    CREATE OR REPLACE FUNCTION trigger_delete_after_a_week()
    RETURNS TRIGGER AS $$
    BEGIN
      DELETE FROM flashcard_sentences WHERE updated_at < current_date - 1;
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
    "
    )
  
    add_timestamps("flashcard_sentences")
  end

  def down do
    drop table(:flashcard_sentences)
  end
end

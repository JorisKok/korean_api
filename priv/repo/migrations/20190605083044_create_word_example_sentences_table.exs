defmodule KoreanApi.Repo.Migrations.CreateWordExampleSentencesTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration
  
  def up do
    create table(:word_example_sentences) do
      add :word_id, references(:words), null: false
      add :example_sentence, :text
    end

    execute("grant select on word_example_sentences to web_anon;")

    create index(:word_example_sentences, [:word_id])

    add_timestamps("word_example_sentences")
  end

  def down do
    drop table(:word_example_sentences)
  end
end

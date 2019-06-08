defmodule KoreanApi.Repo.Migrations.CreateWordExampleSentencesTable do
  use Ecto.Migration

  def up do
    create table(:word_example_sentences) do
      add :word_id, references(:words)
      add :example_sentence, :string
    end
  end

  def down do
    drop table(:word_example_sentences)
  end
end

defmodule KoreanApi.Repo.Migrations.CreateWordKoreanExplanationsTable do
  use Ecto.Migration

  def up do
    create table(:word_korean_explanations) do
      add :word_id, references(:words)
      add :korean_explanation, :string
    end
  end

  def down do
    drop table(:word_korean_explanations)
  end
end

defmodule KoreanApi.Repo.Migrations.CreateWordKoreanExplanationsTable do
  use Ecto.Migration

  def up do
    create table(:word_korean_explanations) do
      add :word_id, references(:words)
      add :korean_explanation, :string
    end

    execute("grant select on word_korean_explanations to web_anon;")

    create index(:word_korean_explanations, [:word_id])
  end

  def down do
    drop table(:word_korean_explanations)
  end
end

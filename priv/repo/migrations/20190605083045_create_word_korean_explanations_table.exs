defmodule KoreanApi.Repo.Migrations.CreateWordKoreanExplanationsTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration

  def up do
    create table(:word_korean_explanations) do
      add :word_id, references(:words, on_delete: :delete_all), null: false
      add :korean_explanation, :text
    end

    execute("grant select on word_korean_explanations to web_anon;")

    create index(:word_korean_explanations, [:word_id])

    add_timestamps("word_korean_explanations")
  end

  def down do
    drop table(:word_korean_explanations)
  end
end

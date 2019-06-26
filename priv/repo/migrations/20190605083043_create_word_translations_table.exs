defmodule KoreanApi.Repo.Migrations.CreateWordTranslationsTable do
  use Ecto.Migration

  def up do
    create table(:word_translations) do
      add :word_id, references(:words)
      # The related korean words is a word that might contain the original word (한국말 for 한국)
      add :related_korean_word, :string
      add :translation, :text, default: "(no equivalent expression)"
      add :definition, :text
    end

    execute("grant select on word_translations to web_anon;")

    create index(:word_translations, [:word_id])
  end

  def down do
    drop table(:word_translations)
  end
end

defmodule KoreanApi.Repo.Migrations.CreateWordTranslationsTable do
  use Ecto.Migration

  def up do
    create table(:word_translations) do
      add :word_id, references(:words)
      add :translation, :string
      add :definition, :string
    end

    execute("grant select on word_translations to web_anon;")
  end

  def down do
    drop table(:word_translations)
  end
end

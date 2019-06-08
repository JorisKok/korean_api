defmodule KoreanApi.Repo.Migrations.CreateWordTranslationsTable do
  use Ecto.Migration

  def up do
    create table(:word_translations) do
      add :word_id, references(:words)
      add :translation, :string
    end
  end

  def down do
    drop table(:word_translations)
  end
end

defmodule KoreanApi.Repo.Migrations.CreateWordTranslationTable do
  use Ecto.Migration

  def up do
    create table(:word_translations) do
      add :word_id, references(:words)
      add :translations, :string
    end
  end

  def down do
    drop table(:word_translations)
  end
end

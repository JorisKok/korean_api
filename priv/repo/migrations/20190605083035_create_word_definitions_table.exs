defmodule KoreanApi.Repo.Migrations.CreateWordDefinitionsTable do
  use Ecto.Migration

  def up do
    create table(:word_definitions) do
      add :word_id, references(:words)
      add :definition, :string
    end
  end

  def down do
    drop table(:word_definitions)
  end
end

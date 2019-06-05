defmodule KoreanApi.Repo.Migrations.CreateWordDefinitionTable do
  use Ecto.Migration

  def up do
    create table(:word_definition) do
      add :word_id, references(:words)
      add :definition, :string
    end
  end

  def down do
    drop table(:word_definition)
  end
end

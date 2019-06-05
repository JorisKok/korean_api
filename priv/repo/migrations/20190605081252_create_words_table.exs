defmodule KoreanApi.Repo.Migrations.CreateWordsTable do
  use Ecto.Migration

  def up do
    create table(:words) do
      add :korean, :string
    end

    create unique_index(:words, [:korean])
  end

  def down do
    drop table(:words)
  end
end

defmodule KoreanApi.Repo.Migrations.CreateWordsTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration

  def up do
    create table(:words) do
      add :korean, :string
    end

    create unique_index(:words, [:korean])

    execute("grant select on words to web_anon;")

    add_timestamps("words")
  end

  def down do
    drop table(:words)
  end
end

defmodule KoreanApi.Helpers.Migration do
  use Ecto.Migration
  
  @moduledoc """
  Postgres migration helpers
  """
  def add_timestamps(table) do
    execute("alter table #{table} add column created_at timestamp;")
    execute("alter table #{table} alter column created_at set default now();")
    execute("alter table #{table} add column updated_at timestamp default now();")
    execute("
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON #{table}
      FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();
    ")
  end
end
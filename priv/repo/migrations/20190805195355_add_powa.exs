defmodule KoreanApi.Repo.Migrations.AddPowa do
  use Ecto.Migration
  
  def up do
    execute "CREATE ROLE powa SUPERUSER LOGIN PASSWORD '#{Application.fetch_env!(:korean_api, :powa_password)}' ;"
    execute "
      CREATE EXTENSION pg_stat_statements;
      CREATE EXTENSION btree_gist;
      CREATE EXTENSION powa;
      CREATE EXTENSION pg_qualstats;
      CREATE EXTENSION pg_stat_kcache;
      CREATE EXTENSION hypopg;
    "
  end
  
  def down do
    execute "drop role powa;"
  end
end

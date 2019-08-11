defmodule KoreanApi.Repo.Migrations.AddPowa do
  use Ecto.Migration
  
  def up do
    execute "CREATE ROLE powa SUPERUSER LOGIN PASSWORD '#{Application.fetch_env!(:korean_api, :powa_password)}' ;"
  end
  
  def down do
    execute "drop role powa;"
  end
end

defmodule KoreanApi.Repo.Migrations.CreateLearnTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration
  
  def up do
    create table(:learn) do
      add :level, :string, null: false
      add :topic, :string, null: false
      add :type, :string, null: false
      add :korean, :string, null: false
      add :translation, :string, null: false
      add :notes, {:array, :string}
      add :email, :string, null: false
      add :difficulty, :integer, null: false
    end
    
    create index(:learn, [:level, :topic, :email])
    
    execute("grant select, insert, delete on learn to web_user;")
    execute("grant usage, select on all sequences in schema public to web_user;")

    execute "CREATE TRIGGER learn_before_trigger
            BEFORE INSERT ON learn
            FOR EACH ROW
            EXECUTE PROCEDURE public.set_email()"
    
    add_timestamps("learn")
  end
  
  def down do
    drop table(:learn)
  end
end

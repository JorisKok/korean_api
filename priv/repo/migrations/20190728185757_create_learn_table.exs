defmodule KoreanApi.Repo.Migrations.CreateLearnTable do
  use Ecto.Migration
  import KoreanApi.Helpers.Migration
  
  def up do
    create table(:learn) do
      add :level, :string
      add :topic, :string
      add :type, :string, null: false
      add :korean, :string, null: false
      add :translation, :string, null: false
      add :notes, {:array, :string}
      add :user_id, :integer, null: false # Reference via execute()
      add :difficulty, :integer, null: false
    end
    
    execute "alter table learn
            add constraint learn_user_id_fkey foreign key (user_id)
            references auth.users (id)
            match simple on update no action on delete cascade"
    create index(:learn, [:level, :topic, :user_id])
    
    execute("grant select, insert, delete on learn to web_anon;")
    execute("grant usage, select on all sequences in schema public to web_anon;")
    
    # TODO add security to only allow changing own user_id items
    
    add_timestamps("learn")
  end
  
  def down do
    drop table(:learn)
  end
end

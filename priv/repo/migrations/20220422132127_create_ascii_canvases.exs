defmodule Canvas.Repo.Migrations.CreateAsciiCanvases do
  use Ecto.Migration

  def change do
    create table(:ascii_canvases) do
      add :hash, :string
      add :data, :map

      timestamps()
    end

    create index(:ascii_canvases, [:hash], unique: true)
  end
end

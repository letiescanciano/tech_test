defmodule Ukio.Repo.Migrations.AddMarketToApartments do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE apartment_market AS ENUM ('mars', 'earth', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto')"

    alter table(:apartments) do
      add :market, :apartment_market, default: "earth"
    end
  end

  def down do
    alter table(:apartments) do
      remove :market
    end

    execute "DROP TYPE apartment_market"
  end
end

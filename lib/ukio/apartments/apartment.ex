defmodule Ukio.Apartments.Apartment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apartments" do
    field :address, :string
    field :monthly_price, :integer
    field :name, :string
    field :square_meters, :integer
    field :zip_code, :string
    field :market, :string, default: "earth"

    timestamps()
  end

  @enforce_keys [:market]
  @valid_markets ["mars", "earth", "jupiter", "saturn", "uranus", "neptune", "pluto"]

  @doc false
  def changeset(apartment, attrs) do
    apartment
    |> cast(attrs, [:name, :address, :zip_code, :monthly_price, :square_meters, :market])
    |> validate_inclusion(:market, @valid_markets)
    |> validate_required([:name, :address, :zip_code, :monthly_price, :square_meters, :market])
  end
end

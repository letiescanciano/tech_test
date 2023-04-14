defmodule Ukio.BookingCreatorTest do
  use Ukio.DataCase

  alias Ukio.Apartments
  alias Ukio.Apartments.Apartment
  alias Ukio.Bookings.Handlers.BookingCreator
  import Ukio.ApartmentsFixtures

  describe "generate_booking_data/3" do
    @mars_apartment_attrs %{
      address: "some address",
      monthly_price: 50000,
      name: "some name",
      square_meters: 100,
      zip_code: "some zip_code",
      market: "mars"
    }
    @earth_apartment_attrs %{
      address: "some address",
      monthly_price: 30000,
      name: "some name",
      square_meters: 150,
      zip_code: "some zip_code",
      market: "earth"
    }
  end

  test "generates data for Mars market" do
    apartment = apartment_fixture(@mars_apartment_attrs)
    check_in = Date.utc_today()
    check_out = Date.utc_today() |> Date.add(30)

    expected_result = %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: 50000,
      utilities: 15000,
      deposit: 50000
    }

    assert BookingCreator.generate_booking_data(apartment, check_in, check_out) == expected_result
  end

  test "generates data for non-Mars market" do
    apartment = apartment_fixture(@earth_apartment_attrs)
    check_in = Date.utc_today()
    check_out = Date.utc_today() |> Date.add(30)

    expected_result = %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: 30000,
      utilities: 20000,
      deposit: 100_000
    }

    assert BookingCreator.generate_booking_data(apartment, check_in, check_out) == expected_result
  end
end

defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments
  alias Ukio.Apartments.Handlers.AvailabilityChecker

  def create(
        %{"check_in" => check_in, "check_out" => check_out, "apartment_id" => apartment_id} =
          params
      ) do
    apartment = Apartments.get_apartment!(apartment_id)

    if AvailabilityChecker.is_apartment_available?(
         apartment_id,
         check_in,
         check_out
       ) do
      booking_data = generate_booking_data(apartment, check_in, check_out)
      Apartments.create_booking(booking_data)
    else
      {:error, :apartment_not_available}
    end
  end

  defp generate_booking_data(apartment, check_in, check_out) do
    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: 20_000,
      deposit: 100_000
    }
  end
end

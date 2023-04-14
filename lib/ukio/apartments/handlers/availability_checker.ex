defmodule Ukio.Apartments.Handlers.AvailabilityChecker do
  import Ecto.Query, warn: false

  alias Ukio.Apartments.Bookings.Booking
  alias Ukio.Repo

  def is_apartment_available?(apartment_id, check_in, check_out) do
    check_availability_query(apartment_id, check_in, check_out) |> Repo.all() |> Enum.empty?()
  end

  def check_availability_query(apartment_id, check_in, check_out) do
    from b in Booking,
      where:
        b.apartment_id == ^apartment_id and
          ((b.check_in <= ^check_in and b.check_out > ^check_in) or
             (b.check_in < ^check_out and b.check_out >= ^check_out) or
             (b.check_in >= ^check_in and b.check_out <= ^check_out)),
      select: b.id
  end
end

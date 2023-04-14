defmodule Ukio.Apartments.Handlers.AvailabilityCheckerTest do
  use Ukio.DataCase

  alias Ukio.Apartments.Handlers.AvailabilityChecker

  import Ukio.ApartmentsFixtures
  import Ukio.BookingsFixtures

  describe "is_apartment_available?/3" do
    @create_attrs %{
      check_in: ~D[2023-03-26],
      check_out: ~D[2023-04-26]
    }

    @appartment_attrs %{
      address: "some address",
      monthly_price: 250_000,
      name: "some name",
      square_meters: 42,
      zip_code: "some zip_code"
    }

    setup do
      {:ok, apartment: apartment_fixture(@appartment_attrs)}
    end

    test "returns true if apartment is available for the specified dates", state do
      assert AvailabilityChecker.is_apartment_available?(
               state[:apartment].id,
               @create_attrs.check_in,
               @create_attrs.check_out
             )
    end

    test "returns false if apartment needs to be booked on the same exact dates as an existing booking",
         state do
      booking_fixture(Map.merge(@create_attrs, %{apartment_id: state[:apartment].id}))

      refute AvailabilityChecker.is_apartment_available?(
               state[:apartment].id,
               @create_attrs.check_in,
               @create_attrs.check_out
             )
    end

    test "returns false if check in date is within a not available period", state do
      # example:
      # existing booking: 2023-03-26 - 2023-04-26
      # new booking:  2023-04-02 - 2023-04-30

      booking_fixture(
        Map.merge(
          %{check_in: ~D[2023-04-02], check_out: ~D[2023-04-30]},
          %{apartment_id: state[:apartment].id}
        )
      )

      refute AvailabilityChecker.is_apartment_available?(
               state[:apartment].id,
               @create_attrs.check_in,
               @create_attrs.check_out
             )
    end

    test "returns false if check out date is within a not available period", state do
      # example:
      # existing booking: 2023-03-26 - 2023-04-26
      # new booking:  2023-03-20 - 2023-04-02

      booking_fixture(
        Map.merge(
          %{check_in: ~D[2023-03-20], check_out: ~D[2023-04-02]},
          %{apartment_id: state[:apartment].id}
        )
      )

      refute AvailabilityChecker.is_apartment_available?(
               state[:apartment].id,
               @create_attrs.check_in,
               @create_attrs.check_out
             )
    end
  end
end

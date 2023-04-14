defmodule UkioWeb.BookingController do
  use UkioWeb, :controller

  alias Ukio.Apartments.Bookings
  alias Ukio.Apartments.Bookings.Booking
  alias Ukio.Apartments.Bookings.Handlers.BookingCreator

  action_fallback UkioWeb.FallbackController

  def create(conn, %{"booking" => booking_params}) do
    case BookingCreator.create(booking_params) do
      {:ok, %Booking{} = booking} ->
        conn
        |> put_status(:created)
        |> render(:show, booking: booking)

      {:error, :apartment_not_available} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "The apartment is not available for the specified dates."})
    end
  rescue
    _ ->
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{errors: %{base: "Invalid booking params"}})
  end

  def show(conn, %{"id" => id}) do
    booking = Bookings.get_booking!(id)
    render(conn, :show, booking: booking)
  end
end

defmodule Squeeze.TimeHelper do
  @moduledoc """
  Module to handle time
  """

  alias Squeeze.Accounts.User

  def today(%User{} = user), do: to_date(Timex.now)

  def to_date(%NaiveDateTime{} = datetime) do
    to_date(Timex.to_datetime(datetime))
  end
  def to_date(datetime) do
    datetime
    |> Timex.to_date()
  end

  def beginning_of_day(date) do
    date
    |> Timex.beginning_of_day()
    |> Timex.to_datetime()
  end

  def end_of_day(date) do
    date
    |> Timex.end_of_day()
    |> Timex.to_datetime()
  end
end

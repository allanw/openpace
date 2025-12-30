defmodule SqueezeWeb.OverviewView do
  use SqueezeWeb, :view

  alias Squeeze.Accounts.User
  alias Squeeze.Distances
  alias Squeeze.TimeHelper

  def title(_page, _assigns) do
    gettext("Dashboard")
  end

  def full_name(%User{} = user), do: User.full_name(user)

  def improvement_amount(%User{} = user), do: User.improvement_amount(user)

  def format_goal(user) do
    1.0
    |> format_duration()
  end

  def race_date(), do: nil

  def weeks_until_race(), do: nil

  def weekly_distance(%{year_dataset: dataset, current_user: user}) do
    distance = dataset
    |> List.last()
    |> Map.get(:distance)
  end

  def weekly_diff(%{year_dataset: dataset}) do
    distances = dataset
    |> Enum.reverse()
    |> Enum.map(&(&1.distance))

    curr_distance = Enum.at(distances, 0)
    prev_distance = Enum.at(distances, 1)
    if prev_distance == 0 do
      nil
    else
      percent = (curr_distance - prev_distance) / prev_distance * 100
      trunc(percent)
    end
  end

  def dates(assigns) do
    today = today(assigns)
    end_date = Timex.end_of_week(today)
    start_date = today |> Timex.shift(weeks: -4) |> Timex.beginning_of_week()
    Date.range(start_date, end_date)
  end

  def today(%{current_user: user}) do
    TimeHelper.today(user)
  end

  def active_on_date?(%{run_dates: dates}, date) do
    dates
    |> Enum.member?(date)
  end

  def streak(%{run_dates: dates, current_user: user}) do
    today = TimeHelper.today(user)
    yesterday = Timex.shift(today, days: -1)
    most_recent_date = List.first(dates)
    if today == most_recent_date || yesterday == most_recent_date do
      streak = dates
      |> Enum.with_index()
      |> Enum.filter(fn({x, idx}) -> x == Timex.shift(most_recent_date, days: -idx) end)
      "#{length(streak)} day streak"
    else
      "0 day streak"
    end
  end
end

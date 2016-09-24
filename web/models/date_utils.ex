defmodule PodcatApi.DateUtils do
  @modeledoc """
  Utils for working with date and time.
  """

  @months %{
    "jan" => 1, "feb" => 2, "mar" => 3, "apr" => 4,  "may" => 5,  "jun" => 6,
    "jul" => 7, "aug" => 8, "sep" => 9, "oct" => 10, "nov" => 11, "dec" => 12,

    "january"  => 1, "february"  => 2, "march"  => 3, "april"     => 4, "may"     => 5,
    "june"     => 6, "july"      => 7, "august" => 8, "september" => 9, "october" => 10,
    "november" => 11, "december" => 12
  }

  defmodule RFC2822 do
    @modeledoc """
    RFC822/2822

    The format of RFC822/2822 is `day-of-week, dd month yy hh:mm:ss timezone`.
    Both the day-of-week and month should be printed in short-form.

    Day-of-week:
    - Mon, Tue, Wed, Thu, Fri, Sat, Sun

    Month (should only be three letters):
    - Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
    - January, February, March, April, May, June, July, August, September, October, November, December

    Timezone:
    - UT, GMT, EST, EDT, CST, CDT, MST, MDT, PST, PDT
    - Military standard (single letter)
    - -/+HHMM

    Via: https://www.ietf.org/rfc/rfc0822.txt (5. DATE AND TIME SPECIFICATION) and
         https://www.ietf.org/rfc/rfc2822.txt (3.3. Date and Time Specification)
    """

    alias PodcatApi.DateUtils

    import String, only: [to_integer: 1]

    @datetime %DateTime{year: 1900, month: 1, day: 1, hour: 0, minute: 0, second: 0,
                        time_zone: "Etc/UTC", zone_abbr: "UTC", utc_offset: 0, std_offset: 0}

    @doc """
    Parse the date-format (RFC822/2822) used in RSS and create a `DateTime.t`.

    ## Example

        iex> PodcatApi.DateUtils.RFC2822.parse("Sun, 19 May 2002 15:21:36 GMT")
        %DateTime{day: 19, month: 5, year: 2002,
                  hour: 15, minute: 21, second: 36, microsecond: {0, 0},
                  std_offset: 0, utc_offset: 0,
                  time_zone: "Etc/UTC", zone_abbr: "UTC"}
    """
    def parse(date),
      do: {String.split(date), @datetime}
          |> weekday |> day |> month |> year |> time |> time_zone |> elem(1)

    defp set({[_ | rest], dt}, nil), do: {rest, dt}
    defp set({[_ | rest], dt}, values), do: {rest, Map.merge(dt, values)}

    # Weekday: Mon, Tue, etc. and "," (optional)
    defp weekday({[<<_::bytes-size(3)>> <> "," | _], _dt} = date), do: date |> set(nil)
    defp weekday(date), do: date

    # Days: d or dd
    defp day({[<<d::bytes-size(1)>> | _], _dt} = date), do: date |> set(%{day: to_integer(d)})
    defp day({[<<dd::bytes-size(2)>> | _], _dt} = date), do: date |> set(%{day: to_integer(dd)})

    # Month: Jan, Feb, etc.
    defp month({[month | _], _dt} = date),
      do: date |> set(%{month: DateUtils.month_to_integer(month)})

    # Year: yy (RFC822) or yyyy (RFC2822)
    defp year({[<<yy::bytes-size(2)>> | _], _dt} = date),
      do: date |> set(%{year: to_integer("19#{yy}")})

    defp year({[<<yyyy::bytes-size(4)>> | _], _dt} = date),
      do: date |> set(%{year: to_integer(yyyy)})

    # Time: hh:mm:ss or hh:mm
    defp time(
      {[<<hh::bytes-size(2)>> <> ":" <>
        <<mm::bytes-size(2)>> <> ":" <>
        <<ss::bytes-size(2)>> | _], _dt} = date
    ),
      do: date |> set(%{hour: to_integer(hh), minute: to_integer(mm), second: to_integer(ss)})

    defp time({[<<hh::bytes-size(2)>> <> ":" <> <<mm::bytes-size(2)>> | _], _dt} = date),
      do: date |> set(%{hour: to_integer(hh), minute: to_integer(mm)})

    # Time zone: +hhmm, -hhmm, hhmm, A-Z or GMT, EST, EDT, etc.
    defp time_zone({["+" <> <<hh::bytes-size(2)>> <> <<mm::bytes-size(2)>> | _], _dt} = date),
      do: date |> set(add_time_zone(:-, to_integer(hh), to_integer(mm)))

    defp time_zone({["-" <> <<hh::bytes-size(2)>> <> <<mm::bytes-size(2)>> | _], _dt} = date),
      do: date |> set(add_time_zone(:+, to_integer(hh), to_integer(mm)))

    defp time_zone({[<<hh::bytes-size(2)>> <> <<mm::bytes-size(2)>> | _], _dt} = date),
      do: date |> set(add_time_zone(:-, to_integer(hh), to_integer(mm)))

    defp time_zone({[<<time_zone::bytes-size(3)>> | rest], dt}),
      do: time_zone({[DateUtils.time_zone(time_zone), rest], dt})

    defp time_zone({[<<time_zone::bytes-size(2)>> | rest], dt}),
      do: time_zone({[DateUtils.time_zone(time_zone), rest], dt})

    defp time_zone({[<<time_zone::bytes-size(1)>> | rest], dt}),
      do: time_zone({[DateUtils.time_zone(time_zone), rest], dt})

    defp time_zone(date), do: date

    defp add_time_zone(sym, 0, min),
      do: %{time_zone: "Etc/UTC", zone_abbr: "UTC", utc_offset: seconds(sym, 0, min)}

    defp add_time_zone(:+, hour, minute),
      do: %{
            time_zone: "Etc/GMT+#{hour}",
            zone_abbr: "GMT+#{hour}",
            utc_offset: seconds(:-, hour, minute)
          }

    defp add_time_zone(:-, hour, minute),
      do: %{
            time_zone: "Etc/GMT-#{hour}",
            zone_abbr: "GMT-#{hour}",
            utc_offset: seconds(:+, hour, minute)
          }

    defp seconds(:+, hour, minute), do: (hour * 60 + minute) * 60
    defp seconds(:-, hour, minute), do: -(hour * 60 + minute) * 60
  end

  @doc """
  Convert time zone from zzz to +/-hhmm.

  ## Example

      iex> PodcatApi.DateUtils.time_zone("CDT")
      "+0500"

  Supports military time zones.

      iex> PodcatApi.DateUtils.time_zone("P")
      "-0300"
  """
  def time_zone("UT"), do: "+0000"
  def time_zone("GMT"), do: "+0000"
  def time_zone("EST"), do: "+0500"
  def time_zone("EDT"), do: "+0400"
  def time_zone("CST"), do: "+0600"
  def time_zone("CDT"), do: "+0500"
  def time_zone("MST"), do: "+0700"
  def time_zone("MDT"), do: "+0600"
  def time_zone("PST"), do: "+0800"
  def time_zone("PDT"), do: "+0700"

  def time_zone("A"), do: "+0100"
  def time_zone("B"), do: "+0200"
  def time_zone("C"), do: "+0300"
  def time_zone("D"), do: "+0400"
  def time_zone("E"), do: "+0500"
  def time_zone("F"), do: "+0600"
  def time_zone("G"), do: "+0700"
  def time_zone("H"), do: "+0800"
  def time_zone("I"), do: "+0900"
  def time_zone("K"), do: "+1000"
  def time_zone("L"), do: "+1100"
  def time_zone("M"), do: "+1200"
  def time_zone("N"), do: "-0100"
  def time_zone("O"), do: "-0200"
  def time_zone("P"), do: "-0300"
  def time_zone("Q"), do: "-0400"
  def time_zone("R"), do: "-0500"
  def time_zone("S"), do: "-0600"
  def time_zone("T"), do: "-0700"
  def time_zone("U"), do: "-0800"
  def time_zone("V"), do: "-0900"
  def time_zone("W"), do: "-1000"
  def time_zone("X"), do: "-1100"
  def time_zone("Y"), do: "-1200"
  def time_zone("Z"), do: "+0000"

  def time_zone(_), do: "+0000"

  @doc """
  Convert month abbr to integer.

  ## Example

      iex> PodcatApi.DateUtils.month_to_integer("Apr")
      4
  """
  def month_to_integer(text), do: @months[String.downcase(text)]
end

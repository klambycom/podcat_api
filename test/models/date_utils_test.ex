defmodule Reader.DateUtilsTest do
  use Reader.ModelCase
  doctest Reader.DateUtils
  doctest Reader.DateUtils.RFC2822

  @valid_date %DateTime{day: 19, month: 5, year: 2002,
                        hour: 15, minute: 21, second: 36, microsecond: {0, 0},
                        std_offset: 0, utc_offset: 0,
                        time_zone: "Etc/UTC", zone_abbr: "UTC"}

  test "parse RFC822 without weekday" do
    assert Reader.DateUtils.RFC2822.parse("19 May 2002 15:21:36 GMT") == @valid_date
  end

  test "parse RFC822 with time zone (+hhmm)" do
    date = %{@valid_date | utc_offset: +3600, time_zone: "Etc/GMT-1", zone_abbr: "GMT-1"}
    assert Reader.DateUtils.RFC2822.parse("19 May 2002 15:21:36 +0100") == date
  end

  test "parse RFC822 with time zone with minutes (+hhmm)" do
    date = %{@valid_date | utc_offset: +5400, time_zone: "Etc/GMT-1", zone_abbr: "GMT-1"}
    assert Reader.DateUtils.RFC2822.parse("19 May 2002 15:21:36 +0130") == date
  end

  test "parse RFC822 with single digit day" do
    date = %{@valid_date | day: 1}
    assert Reader.DateUtils.RFC2822.parse("1 May 2002 15:21:36 GMT") == date
  end

  test "parse RFC822 without +/- in front of time zone" do
    date = %{@valid_date | day: 1, utc_offset: +3600, time_zone: "Etc/GMT-1", zone_abbr: "GMT-1"}
    assert Reader.DateUtils.RFC2822.parse("1 May 2002 15:21:36 0100") == date
  end

  test "parse RFC822 with two digit year" do
    date = %{@valid_date | day: 26, month: 4, year: 1988}
    assert Reader.DateUtils.RFC2822.parse("26 Apr 88 15:21:36 GMT") == date
  end

  test "parse RFC822 with only HH:MM and not SS" do
    date = %{@valid_date | day: 1, second: 00, year: 1988}
    assert Reader.DateUtils.RFC2822.parse("1 May 88 15:21 GMT") == date
  end

  test "parse RFC822 with CST time zone" do
    date = %{
      @valid_date |
      day: 1,
      second: 00,
      year: 1988,
      utc_offset: +21600,
      time_zone: "Etc/GMT-6",
      zone_abbr: "GMT-6"
    }
    assert Reader.DateUtils.RFC2822.parse("1 May 88 15:21 CST") == date
  end

  test "parse RFC822 with military time zone" do
    date = %{@valid_date | utc_offset: +36000, time_zone: "Etc/GMT-10", zone_abbr: "GMT-10"}
    assert Reader.DateUtils.RFC2822.parse("Sun, 19 May 2002 15:21:36 K") == date
  end

  test "parse RFC822 with negative time zone" do
    date = %{@valid_date | utc_offset: -3600, time_zone: "Etc/GMT+1", zone_abbr: "GMT+1"}
    assert Reader.DateUtils.RFC2822.parse("19 May 2002 15:21:36 -0100") == date
  end
end

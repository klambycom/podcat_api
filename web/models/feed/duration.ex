defmodule Reader.Feed.Duration do
  @moduledoc """
  Ecto type for enclosure duration. The duration is represented as seconds in the
  DB and a tuple in the code (`{hh, mm, ss}`).

  Supported formats:
  - h:mm:ss
  - hh:mm:ss
  - mm:ss
  - m:ss
  - ssss
  """

  import String, only: [to_integer: 1]

  @behaviour Ecto.Type

  @doc false
  def type, do: :integer

  @doc false
  def cast(<<hours::bytes-size(1)>> <> ":" <> <<minutes::bytes-size(2)>> <> ":" <> seconds),
    do: {:ok, calculate(to_integer(hours), to_integer(minutes), to_integer(seconds))}

  def cast(<<hours::bytes-size(2)>> <> ":" <> <<minutes::bytes-size(2)>> <> ":" <> seconds),
    do: {:ok, calculate(to_integer(hours), to_integer(minutes), to_integer(seconds))}

  def cast(<<minutes::bytes-size(1)>> <> ":" <> seconds),
    do: {:ok, calculate(0, to_integer(minutes), to_integer(seconds))}

  def cast(<<minutes::bytes-size(2)>> <> ":" <> seconds),
    do: {:ok, calculate(0, to_integer(minutes), to_integer(seconds))}

  def cast(seconds) when is_binary(seconds), do: {:ok, calculate(0, 0, to_integer(seconds))}

  def cast(_), do: :error

  @doc false
  def load(seconds),
    do: {
          :ok,
          {
            rem(div(div(seconds, 60), 60), 60),
            rem(div(seconds, 60), 60),
            rem(seconds, 60)
          }
        }

  @doc false
  def dump({hours, minutes, seconds}), do: {:ok, calculate(hours, minutes, seconds)}

  defp calculate(hours, minutes, seconds), do: (hours * 60 + minutes) * 60 + seconds
end

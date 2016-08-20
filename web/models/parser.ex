defmodule Reader.Parser do
  @callback valid?(tuple) :: boolean
  @callback parse(tuple) :: map

  @parsers Application.get_env(:reader, :parsers)

  @doc """
  Parse a document with the correct parser.

  TODO Allow more than one parser, and just update the response with new/more data.
  """
  def parse(document), do: parse(document, get(@parsers, document))

  def parse(_document, nil), do: :error
  def parse(document, parser), do: {:ok, parser.parse(document)}

  @doc """
  Find and return the parser that can parse the document.
  """
  def get([parser | rest], document) do
    if parser.valid?(document) do
      parser
    else
      get(rest, document)
    end
  end

  def get(_, _), do: nil
end

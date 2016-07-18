defmodule Reader.Xml do
  @moduledoc """
  Parse XML.
  """

  require Record

  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlNamespace, from_lib: "xmerl/include/xmerl.hrl")

  @doc """
  Parse the XML from a string.
  """
  def from_string(xml_string, options \\ []) do
    {doc, []} =
      xml_string
      |> :erlang.bitstring_to_list
      |> :xmerl_scan.string(options)

    doc
  end

  @doc """
  Extract the text from a XML-node.

  ## Example

      iex> [xml_node] =
      ...>   Reader.Xml.from_string("<channel><title>Klamby Blog</title></channel>")
      ...>   |> Reader.Xml.xpath("/channel/title")
      ...>
      ...> Reader.Xml.text(xml_node)
      "Klamby Blog"

  Text from the first XML-element is returned if the element is in a list:

      iex> Reader.Xml.from_string("<channel><title>Klamby Blog</title></channel>")
      ...> |> Reader.Xml.xpath("/channel/title")
      ...> |> Reader.Xml.text
      "Klamby Blog"

  Or `nil` if there is no text:

      iex> Reader.Xml.from_string("<channel><title></title></channel>")
      ...> |> Reader.Xml.xpath("/channel/title")
      ...> |> Reader.Xml.text
      nil
  """
  def text([]), do: []
  def text([xml_node]), do: text(xml_node)

  def text(xml_node), do: xml_node |> xpath("./text()") |> extract_text

  @doc """
  Get a attribute from a XML-node. Returns `nil` if the attribute is missing.

  ## Example

      iex> [xml_node] =
      ...>   Reader.Xml.from_string("<rss version='2.0'></rss>")
      ...>   |> Reader.Xml.xpath("/rss")
      ...>
      ...> Reader.Xml.attr(xml_node, "version")
      "2.0"

  The attribute from the first XML-element is returned if the element is in a list:

      iex> Reader.Xml.from_string("<rss version='2.0'></rss>")
      ...> |> Reader.Xml.xpath("/rss")
      ...> |> Reader.Xml.attr("version")
      "2.0"
  """
  def attr([], _), do: []
  def attr([xml_node], name), do: attr(xml_node, name)

  def attr(xml_node, name), do: xml_node |> xpath("./@#{name}") |> extract_attr

  @doc """
  Xpath.
  """
  def xpath([], _), do: []
  def xpath([xml_node], path), do: xpath(xml_node, path)

  def xpath(xml_node, path),
    do: path
        |> String.to_charlist
        |> :xmerl_xpath.string(xml_node)

  defp extract_text([xmlText(value: value)]), do: List.to_string(value)
  defp extract_text(_), do: nil

  defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
  defp extract_attr(_), do: nil
end

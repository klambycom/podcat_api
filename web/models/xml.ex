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
  Check if a namespace exist.

  ## Example

      iex> Reader.Xml.from_string(
      ...>   \"\"\"
      ...>   <?xml version="1.0" encoding="UTF-8" ?>
      ...>   <rss
      ...>     xmlns:cc="http://web.resource.org/cc/"
      ...>     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
      ...>     version="2.0"
      ...>   >
      ...>     <channel>
      ...>       <title>Klamby Podcast</title>
      ...>     </channel>
      ...>   </rss>
      ...>   \"\"\"
      ...> )
      ...> |> Reader.Xml.namespace?(:itunes)
      true
  """
  def namespace?(xml_node, namespace),
    do: xml_node |> namespaces |> Map.has_key?(namespace)

  @doc """
  Extract all namespaces from the document.

  ## Example

      iex> Reader.Xml.from_string(
      ...>   \"\"\"
      ...>   <?xml version="1.0" encoding="UTF-8" ?>
      ...>   <rss
      ...>     xmlns:cc="http://web.resource.org/cc/"
      ...>     xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
      ...>     version="2.0"
      ...>   >
      ...>     <channel>
      ...>       <title>Klamby Podcast</title>
      ...>     </channel>
      ...>   </rss>
      ...>   \"\"\"
      ...> )
      ...> |> Reader.Xml.namespaces
      %{
        cc: "http://web.resource.org/cc/",
        itunes: "http://www.itunes.com/dtds/podcast-1.0.dtd"
      }
  """
  def namespaces(xmlElement(namespace: xmlNamespace(nodes: namespaces))),
    do: Enum.reduce(namespaces, %{}, fn({key, value}, acc) ->
          Map.put(acc, List.to_atom(key), Atom.to_string(value))
        end)

  def namespaces(_), do: %{}

  @doc """
  Extract the text from a XML-node.

  ## Example

      iex> [xml_node] =
      ...>   Reader.Xml.from_string("<channel><title>Klamby Blog</title></channel>")
      ...>   |> Reader.Xml.xpath("/channel/title")
      ...>
      ...> Reader.Xml.text(xml_node)
      "Klamby Blog"

  Text from the all XML-elements is returned in a list:

      iex> Reader.Xml.from_string("<channel><title>Klamby Blog</title></channel>")
      ...> |> Reader.Xml.xpath("/channel/title")
      ...> |> Reader.Xml.text
      "Klamby Blog"

  Or empty string if there is no text:

      iex> Reader.Xml.from_string("<channel><title></title></channel>")
      ...> |> Reader.Xml.xpath("/channel/title")
      ...> |> Reader.Xml.text
      ""
  """
  def text(xmlElement(content: content)), do: text(content, "")
  def text([xmlElement(content: content)]), do: text(content, "")
  def text(_), do: nil

  defp text([], str), do: str
  defp text([xmlText(value: value) | rest], str),
    do: text(rest, str <> List.to_string(value))

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
  def attr([], _), do: nil
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

  defp extract_attr([xmlAttribute(value: value)]), do: List.to_string(value)
  defp extract_attr(_), do: ""
end

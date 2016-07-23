defmodule Reader.XmlTest do
  use Reader.ModelCase
  doctest Reader.Xml

  test "get text with special characters" do
    doc = Reader.Xml.from_string("<channel><description>Christian&#039;s test of special characters</description></channel>")
    [desc_node] = Reader.Xml.xpath(doc, "/channel/description")

    assert Reader.Xml.text(desc_node) == "Christian's test of special characters"
  end
end

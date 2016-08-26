defmodule PodcatApi.XmlTest do
  use PodcatApi.ModelCase
  doctest PodcatApi.Xml

  test "get text with special characters" do
    doc = PodcatApi.Xml.from_string("<channel><description>Christian&#039;s test of special characters</description></channel>")
    [desc_node] = PodcatApi.Xml.xpath(doc, "/channel/description")

    assert PodcatApi.Xml.text(desc_node) == "Christian's test of special characters"
  end
end

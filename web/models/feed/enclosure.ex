defmodule PodcatApi.Feed.Enclosure do
  @moduledoc """
  RSS enclosure, attached multimedia content by providing URL to the file, size
  of the file in bytes (length) and the mime type.

  Supported formats for podcasts:
  - MP3 (MPEG Layer 3)
  - M4A / ACC (Advanced Audio Coding)
  - Ogg (Vorbis)
  - WMA (Windows Audio Media)
  """

  use PodcatApi.Web, :model

  alias PodcatApi.Xml.ItunesParser

  embedded_schema do
    field :url, :string
    field :length, :integer
    field :type, :string
  end

  @required_fields ~w(url length type)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{})

  def changeset(struct, %ItunesParser.Enclosure{url: url, size: size, type: type}),
    do: changeset(struct, %{url: url, length: size, type: type})

  def changeset(struct, params),
    do: struct
        |> cast(params, @required_fields, @optional_fields)
end

defmodule PodcatApi.Feed.Image do
  alias PodcatApi.Feed

  @http_client Application.get_env(:podcat_api, :http_client)

  @doc """
  Download the image.
  """
  def download(%Feed{id: id, image_url: image_url}) do
    response = @http_client.get!(image_url)
    content_type = content_type_from_header(response.headers)

    path = temporary_path(id, content_type)
    File.write!(path, response.body)

    {content_type, path}
  end

  @doc """
  Resize image and open the file.
  """
  def resize(path, size) do
    resized_image =
      Mogrify.open(path)
      |> Mogrify.resize("#{size}x#{size}")
      |> Mogrify.save(in_place: true)

    File.read(resized_image.path)
  end

  @doc """
  Get file extionsion from content type.
  """
  def file_extension("image/jpeg"), do: "jpg"
  def file_extension("image/png"), do: "png"

  defp content_type_from_header(headers) do
    case List.keyfind(headers, "Content-Type", 0) do
      {"Content-Type", "image/jpeg"} -> "image/jpeg"
      {"Content-Type", "image/png"} -> "image/png"
      {"Content-Type", "image/x-png"} -> "image/png"
    end
  end

  defp temporary_path(id, content_type) do
    random = :crypto.rand_uniform(100_000, 999_999)
    Path.join(System.tmp_dir, "#{random}-#{id}.#{file_extension(content_type)}")
  end
end

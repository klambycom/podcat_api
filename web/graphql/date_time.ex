defmodule PodcatApi.GraphQL.DateTime do
  use PodcatApi.Web, :graphql

  def new(opts) do
    description = Map.get(opts, :description, "Date and time")
    type = Map.get(opts, :type)

    %{
      name: "DateTime",
      type: %String{},
      description: description,
      args: %{
        field: %{type: type},
        format: %{
          type: %String{},
          description: "Format the date and time"
        }
      },
      resolve: {__MODULE__, :datetime}
    }
  end

  def datetime(item, args, _) do
    field = Map.get(args, :field)
    format = Map.get(args, :format, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")

    Map.get(item, field)
    |> Timex.format!(format)
  end
end

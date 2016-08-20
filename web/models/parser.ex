defmodule Reader.Parser do
  @callback valid?(tuple) :: boolean
  @callback parse(tuple) :: map
end

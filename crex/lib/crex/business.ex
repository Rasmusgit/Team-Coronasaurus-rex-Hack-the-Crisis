defmodule Crex.Business do
  use ParamSchema

  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:description, :string)
    field(:type, :string)
    field(:city, :string)
    field(:image_url, :string)
  end
end

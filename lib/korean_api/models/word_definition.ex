defmodule KoreanApi.Models.WordDefinition do
  use Ecto.Schema

  schema "word_definitions" do
    belongs_to :word, KoreanApi.Models.Word
    field :definition, :string
  end
end

defmodule KoreanApi.Models.Word do
  use Ecto.Schema

  schema "words" do
    field :korean, :string
    has_many :word_definitions, KoreanApi.Models.WordDefinition
    has_many :word_translations, KoreanApi.Models.WordTranslation
  end
end
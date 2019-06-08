defmodule KoreanApi.Models.WordTranslation do
  use Ecto.Schema

  schema "word_translations" do
    belongs_to :word, KoreanApi.Models.Word
    field :translation, :string
  end
end

defmodule KoreanApi.Models.WordTranslation do
  @moduledoc """
  The translations and definitions
  """
  use Ecto.Schema

  schema "word_translations" do
    belongs_to(:word, KoreanApi.Models.Word)
    field(:related_korean_word, :string)
    field(:translation, :string)
    field(:definition, :string)
  end
end

defmodule KoreanApi.Models.WordKoreanExplanation do
  @moduledoc """
  The korean explanations
  """
  use Ecto.Schema

  schema "word_korean_explanations" do
    belongs_to(:word, KoreanApi.Models.Word)
    field(:korean_explanation, :string)
  end
end

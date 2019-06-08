defmodule KoreanApi.Models.Word do
  use Ecto.Schema

  schema "words" do
    field(:korean, :string)
    has_many(:word_translations, KoreanApi.Models.WordTranslation)
    has_many(:word_example_sentences, KoreanApi.Models.WordExampleSentence)
    has_many(:word_korean_explanations, KoreanApi.Models.WordKoreanExplanation)
  end
end

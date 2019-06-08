defmodule KoreanApi.Models.WordExampleSentence do
  use Ecto.Schema

  schema "word_example_sentences" do
    belongs_to(:word, KoreanApi.Models.Word)
    field(:example_sentence, :string)
  end
end

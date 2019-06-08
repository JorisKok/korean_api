defmodule KoreanApi.Services.KoreanDictionaryService do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Repo
  alias KoreanApi.Models.Word
  alias KoreanApi.Models.WordTranslation
  alias KoreanApi.Models.WordExampleSentence
  alias KoreanApi.Models.WordKoreanExplanation

  @doc """
  Store the translations and the word if found
  Returns :ok if found and stored
  """
  def korean_to_english(korean, word \\ nil) do
    case KoreanDictionary.korean_to_english(korean) do
      [] ->
        :not_found

      result ->
        if word == nil do
          # Insert the word only when we found a translation
          {:ok, word} = Repo.insert(%Word{korean: korean})
        end

        Enum.each(
          result,
          fn {translation, definition} ->
            Repo.insert!(%WordTranslation{
              word_id: word.id,
              translation: translation,
              definition: definition
            })
          end
        )

        {:ok, word}
    end
  end

  @doc """
  Store the korean explanations
  Returns :ok if found and stored
  """
  def korean_to_korean(korean, %Word{} = word) do
    case KoreanDictionary.korean_to_korean(korean) do
      [] ->
        :not_found

      result when is_list(result) ->
        Enum.each(
          result,
          fn korean_explanation ->
            Repo.insert!(%WordKoreanExplanation{
              word_id: word.id,
              korean_explanation: korean_explanation
            })
          end
        )

        :ok

      korean_explanation ->
        Repo.insert!(%WordKoreanExplanation{
          word_id: word.id,
          korean_explanation: korean_explanation
        })

        :ok
    end
  end

  @doc """
  Store the example sentences
  Returns :ok if found and stored
  """
  def korean_example_sentences(korean, %Word{} = word) do
    case KoreanDictionary.korean_example_sentences(korean) do
      [] ->
        :not_found

      result when is_list(result) ->
        Enum.each(
          result,
          fn example_sentence ->
            Repo.insert!(%WordExampleSentence{
              word_id: word.id,
              example_sentence: example_sentence
            })
          end
        )

        :ok

      example_sentence ->
        Repo.insert!(%WordExampleSentence{word_id: word.id, example_sentence: example_sentence})
        :ok
    end
  end
end

defmodule KoreanApi.Controllers.WordController do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Repo
  alias KoreanApi.Models.Word
  alias KoreanApi.Models.WordTranslation
  alias KoreanApi.Models.WordExampleSentence
  alias KoreanApi.Models.WordKoreanExplanation

  @doc """
  Get the word from the database
  Else get it from KRDict
  Else analyse it, and get it from KRDict
  """
  def get("korean=eq." <> parameters) do
    parameters = String.split(parameters, "&")
    word = URI.decode(hd(parameters))
    other_parameters = tl(parameters) # We need to pass these along to get access to selects, filters etc

    with :not_found <- get_from_database(word, other_parameters),
         :not_found <- get_from_krdict(word, other_parameters) do
      # TODO analyse + get from database
      []
    end
  end

  @doc """
  Anything that is not a GET for a specific word, we just forward to PostgREST
  """
  def get(query_string) do
    with :not_found <- get_from_database(query_string, []) do
      []
    end
  end

  defp get_from_database(word, other_parameters) when is_list(other_parameters) do
    HTTPoison.start()

    case HTTPoison.get!(
           Application.fetch_env!(:korean_api, :postgrest_url) <>
           "/words?korean=eq." <> URI.encode(word) <> "&" <> Enum.join(other_parameters, "&")
         ).body do
      "[]" ->
        :not_found

      result ->
        result
    end
  end

  defp get_from_krdict(korean, other_parameters) when is_list(other_parameters) do
    # Store the word
    {:ok, word} = Repo.insert(%Word{korean: korean})

    # Store the definitions and translations
    case KoreanDictionary.korean_to_english(korean) do
      [] ->
        :not_found

      result ->
        Enum.each(
          result,
          fn {translation, definition} ->
            Repo.insert!(%WordTranslation{word_id: word.id, translation: translation, definition: definition})
          end
        )
    end

    # Store the example sentences
    case KoreanDictionary.korean_to_korean(korean) do
      [] ->
        :not_found

      result when is_list(result) ->
        Enum.each(
          result,
          fn korean_explanation ->
            Repo.insert!(%WordKoreanExplanation{word_id: word.id, korean_explanation: korean_explanation})
          end
        )
      korean_explanation ->
        Repo.insert!(%WordKoreanExplanation{word_id: word.id, korean_explanation: korean_explanation})
    end

    # Store the korean explanations
    case KoreanDictionary.korean_example_sentences(korean) do
      [] ->
        :not_found

      result when is_list(result) ->
        Enum.each(
          result,
          fn example_sentence ->
            Repo.insert!(%WordExampleSentence{word_id: word.id, example_sentence: example_sentence})
          end
        )
        example_sentence -> Repo.insert!(%WordExampleSentence{word_id: word.id, example_sentence: example_sentence})
    end

    # Get it from the database
    get_from_database(korean, other_parameters)
  end
end

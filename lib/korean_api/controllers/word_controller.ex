defmodule KoreanApi.Controllers.WordController do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Services.KoreanDictionaryService

  @doc """
  Get the word from the database
  Else get it from KRDict
  Else analyse it, and get it from KRDict
  """
  def get("korean=eq." <> parameters) do
    parameters = String.split(parameters, "&")
    word = URI.decode(hd(parameters))
    # We need to pass these along to get access to selects, filters etc
    other_parameters = tl(parameters)

    with :not_found <- get_from_database(word, other_parameters),
         :not_found <- get_from_krdict(word, other_parameters),
         :not_found <- get_from_analysed(word, other_parameters) do
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
    with {:ok, word} <- KoreanDictionaryService.korean_to_english(korean),
         :ok <- KoreanDictionaryService.korean_to_korean(korean, word),
         :ok <- KoreanDictionaryService.korean_example_sentences(korean, word) do
      # Get it from the database, so we can use the PostgREST queries
      get_from_database(korean, other_parameters)
    end
  end

  defp get_from_krdict_by_analysed(stem, korean, other_parameters)
       when is_list(other_parameters) do
    with {:ok, word} <- KoreanDictionaryService.korean_to_english(stem, korean),
         :ok <- KoreanDictionaryService.korean_to_korean(stem, word),
         :ok <- KoreanDictionaryService.korean_example_sentences(stem, word) do
      # Get it from the database, so we can use the PostgREST queries
      get_from_database(korean, other_parameters)
    end
  end

  defp get_from_analysed(korean, other_parameters) when is_list(other_parameters) do
    stem = KoreanSentenceAnalyser.get_the_stem_of_a_word(korean)

    get_from_krdict_by_analysed(stem, korean, other_parameters)
  end
end

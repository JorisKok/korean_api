defmodule KoreanApi.Controllers.WordController do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Services.KoreanDictionaryService
  alias KoreanApi.Repo
  alias KoreanApi.Models.Word

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

  defp get_from_krdict_by_analysed(korean, word, other_parameters)
       when is_list(other_parameters) do
    with {:ok, _} <- KoreanDictionaryService.korean_to_english(korean, word),
         :ok <- KoreanDictionaryService.korean_to_korean(korean, word),
         :ok <- KoreanDictionaryService.korean_example_sentences(korean, word) do
      # Get it from the database, so we can use the PostgREST queries
      get_from_database(korean, other_parameters)
    end
  end

  defp get_from_analysed(korean, other_parameters) when is_list(other_parameters) do
    stem = KoreanSentenceAnalyser.get_the_stem_of_a_word(korean)

    case get_from_database(stem, other_parameters) do
      :not_found ->
        # Save based on the searched value, so that it's fast to receive the next time
        {:ok, word} = Repo.insert(%Word{korean: stem})

        get_from_krdict_by_analysed(stem, word, other_parameters)

      result ->
        result
    end
  end
end

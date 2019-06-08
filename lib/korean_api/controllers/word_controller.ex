defmodule KoreanApi.Controllers.WordController do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Repo
  alias KoreanApi.Models.Word
  alias KoreanApi.Models.WordDefinition
  alias KoreanApi.Models.WordTranslation

  @doc """
  Get the word from the database
  Else get it from KRDict
  Else analyse it, and get it from KRDict
  """
  def get("korean=eq." <> encoded_word) do
    word = URI.decode(encoded_word)
    with :not_found <- get_from_database(word),
         :not_found <- get_from_krdict(word) do
      # TODO analyse + get from database
      []
    end
  end

  #  def get("eq" <> word <> rest) do
  #    # TODO, if you include more stuff and relations etc
  #  end

  @doc """
  Anything that is not a GET for a specific word, we just forward to PostgREST
  """
  def get(query_string) do
    IO.inspect query_string
    with :not_found <- get_from_database(query_string) do
      []
    end
  end

  defp get_from_database(query_string) do
    HTTPoison.start()
    case HTTPoison.get!(
           Application.fetch_env!(:korean_api, :postgrest_url) <> "/words?korean=eq." <> URI.encode(query_string)
         ).body do
      "[]" ->
        :not_found
      result ->
        result
    end
  end

  defp get_from_krdict(word) do
    case KoreanDictionary.korean_to_english(word) do
      [] ->
        :not_found
      result ->
        # Store the word
        {:ok, word} = Repo.insert(%Word{korean: word})

        # Store the definitions and translations
        IO.inspect result
        Enum.each(
          result,
          fn {translation, definition} ->
            Repo.insert!(Ecto.build_assoc(word, :word_definitions, %{definition: definition}))
            Repo.insert!(Ecto.build_assoc(word, :word_translations, %{translation: translation}))
          end
        )
    end

    # Get it from the database
    get_from_database(word)
  end
end
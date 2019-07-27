defmodule KoreanApi.Controllers.WordController do
  @moduledoc """
  The Korean word endpoints
  """
  alias KoreanApi.Services.KoreanDictionaryService
  alias KoreanApi.Repos.WordRepo
  
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
        # In case we missed some, if we refresh we should get it again
        get_missing_translations(Jason.decode!(result))
        
        # Return our result, we will get the added on the next request
        result
    end
  end
  
  defp get_from_krdict(korean, other_parameters) when is_list(other_parameters) do
    # Call the KRDict async
    task_korean_to_english = Task.async(fn -> KoreanDictionary.korean_to_english(korean) end)
    task_korean_to_korean = Task.async(fn -> KoreanDictionary.korean_to_korean(korean) end)
    task_korean_example_sentences = Task.async(fn -> KoreanDictionary.korean_example_sentences(korean) end)
    
    with {:ok, word} <- KoreanDictionaryService.korean_to_english(korean, Task.await(task_korean_to_english, 50_000)),
         :ok <- KoreanDictionaryService.korean_to_korean(korean, word, Task.await(task_korean_to_korean, 50_000)),
         :ok <- KoreanDictionaryService.korean_example_sentences(korean, word, Task.await(task_korean_example_sentences, 50_000)) do
      # Get it from the database, so we can use the PostgREST queries
      get_from_database(korean, other_parameters)
    end
  end
  
  defp get_from_krdict_by_analysed(stem, korean, other_parameters)
       when is_list(other_parameters) do
  
    # Call the KRDict async
    task_korean_to_english = Task.async(fn -> KoreanDictionary.korean_to_english(korean) end)
    task_korean_to_korean = Task.async(fn -> KoreanDictionary.korean_to_korean(korean) end)
    task_korean_example_sentences = Task.async(fn -> KoreanDictionary.korean_example_sentences(korean) end)
    
    with {:ok, word} <- KoreanDictionaryService.korean_to_english(stem, korean, Task.await(task_korean_to_english, 50_000)),
         :ok <- KoreanDictionaryService.korean_to_korean(stem, word, Task.await(task_korean_to_korean, 50_000)),
         :ok <- KoreanDictionaryService.korean_example_sentences(stem, word, Task.await(task_korean_example_sentences, 50_000)) do
      # Get it from the database, so we can use the PostgREST queries
      get_from_database(korean, other_parameters)
    end
  end
  
  defp get_from_analysed(korean, other_parameters) when is_list(other_parameters) do
    stem = KoreanSentenceAnalyser.get_the_stem_of_a_word(korean)
    
    get_from_krdict_by_analysed(stem, korean, other_parameters)
  end
  
  defp get_missing_translations([translation]) do
    korean = Map.get(translation, "korean")
    word = WordRepo.get_by_korean!(korean)
    
    if (Map.get(translation, "word_translations") == []) do
      KoreanDictionaryService.korean_to_english(word, KoreanDictionary.korean_to_english(korean))
    end

    if (Map.get(translation, "word_korean_explanations") == []) do
      KoreanDictionaryService.korean_to_korean(korean, word, KoreanDictionary.korean_to_korean(korean))
    end
    
    if (Map.get(translation, "word_example_sentences") == []) do
      KoreanDictionaryService.korean_example_sentences(korean, word, KoreanDictionary.korean_example_sentences(korean))
    end

  end
end

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
  Store the translations if the word already exists
  Returns :ok if found and stored
  """
  
  def korean_to_english(%Word{} = _word, []) do
    :not_found
  end
  
  def korean_to_english(%Word{} = word, result) do
    # The word already exists, so we just store the translations
    
    # Store the translations
    Enum.each(
      result,
      
      # The related korean words is a word that might contain the original word (한국말 for 한국)
      fn %{word: related_korean_word, translations: translations} ->
        Enum.each(
          translations,
          fn {translation, definition} ->
            Repo.insert!(
              %WordTranslation{
                word_id: word.id,
                related_korean_word: related_korean_word,
                translation: translation,
                definition: definition
              }
            )
          end
        )
      end
    )
    
    {:ok, word}
  end
  
  def korean_to_english(korean, result) do
    word = Repo.insert!(%Word{korean: korean})
    korean_to_english(word, result)
  end
  
  @doc """
  Store the korean explanations
  Returns :ok if found and stored
  """
  def korean_to_korean(_korean, %Word{} = _word, []) do
    :not_found
  end
  
  def korean_to_korean(_korean, %Word{} = word, result) when is_list(result) do
    Enum.each(
      result,
      fn korean_explanation ->
        Repo.insert!(
          %WordKoreanExplanation{
            word_id: word.id,
            korean_explanation: korean_explanation
          }
        )
      end
    )
    
    :ok
  end
  
  def korean_to_korean(_korean, %Word{} = word, result) do
    Repo.insert!(
      %WordKoreanExplanation{
        word_id: word.id,
        korean_explanation: result
      }
    )
    
    :ok
  end
  
  @doc """
  Store the example sentences
  Returns :ok if found and stored
  """
  def korean_example_sentences(_korean, %Word{} = _word, []) do
    :not_found
  end
  
  def korean_example_sentences(_korean, %Word{} = word, result) when is_list(result) do
    Enum.each(
      result,
      fn example_sentence ->
        Repo.insert!(
          %WordExampleSentence{
            word_id: word.id,
            example_sentence: example_sentence
          }
        )
      end
    )
    
    :ok
  end
  
  def korean_example_sentences(_korean, %Word{} = word, result) do
    Repo.insert!(%WordExampleSentence{word_id: word.id, example_sentence: result})
    :ok
  end
end

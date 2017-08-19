module ToInt.Foldl exposing (..)

import Char

toInt : String -> Int
toInt original =
  let 
    helper acc characters = 
      case String.uncons characters of 
        Nothing -> 
          acc
        Just (currentChar, newCharacters) ->
          helper (10 * acc + charToDigit currentChar)
                 newCharacters
  in
    helper 0 original


charToDigit : Char -> Int 
charToDigit char =
  Char.toCode char - Char.toCode '0'
      

module ToInt.FixedStringFast exposing
  (..
  )

import Char

charToDigit : Char -> Maybe Int 
charToDigit char =
  case Char.isDigit char of
    True -> Just <| Char.toCode char - Char.toCode '0'
    False -> Nothing

                       


calc : Char -> Maybe Int -> Maybe Int
calc char maybe = 
  case maybe of
    Nothing -> Nothing
    Just acc ->
      case charToDigit char of
        Nothing -> Nothing
        Just digit ->
          Just (acc * 10 + digit)

            

calc2 char maybe =
  let
    addDigitTo acc digit =
      acc * 10 + digit
    addChar acc =
      Maybe.map (addDigitTo acc) (charToDigit char)
  in
    Maybe.andThen addChar maybe

            
maxLength = 10

err : String -> Result String Int
err original =
  Err ("could not convert string '" ++ original ++ "' to an Int")
            

module ToInt.Simple exposing (..)

import Char
import Maybe.Extra as Maybe

toInt: Int -> String -> Int
toInt acc remainder = 
  case String.uncons remainder of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      let
        newSoFar = (10 * acc + charToDigit currentChar)
      in 
        toInt newSoFar newRemainingString

toIntPlus : (Char -> Int -> Int) -> Int -> String
          -> Int
toIntPlus f acc remainder =
  case String.uncons remainder of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      toIntPlus f (f currentChar acc) newRemainingString

toIntStep : Char -> Int -> Int
toIntStep currentChar acc = 
  10 * acc + charToDigit currentChar

moreGeneral : (Char -> acc -> acc) -> acc -> String
            -> acc
moreGeneral f acc remainder =
  case String.uncons remainder of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      moreGeneral f (f currentChar acc) newRemainingString

        
listGeneral : (any -> acc -> acc) -> acc -> List any
             -> acc
listGeneral f acc rest =
  case rest of 
    [] -> 
      acc
    current :: newRest ->
      listGeneral f (f current acc) newRest

factorial n =
  if n <= 1 then
    1
  else
    (*) n (factorial (n - 1))

tailFactorial acc n =
  if n <= 1 then
    acc
  else
    tailFactorial (n * acc) (n - 1)

factorialWithHelper original =
  let 
    helper acc n = 
      if n <= 1 then
        acc
      else
        helper (n * acc) (n - 1)
  in
    helper 1 original

subtractAll : Int -> List String -> Maybe Int      
subtractAll acc strings =
  case strings of
    [] ->
      Just acc
    first :: rest -> 
      case String.toInt first of
        Err _ ->
          Nothing
        Ok int ->
          subtractAll (acc - int) rest

subtractAll2 : Int -> List String -> Maybe Int      
subtractAll2 acc strings =
  case strings of
    [] ->
      Just acc
    first :: rest ->
      first
        |> String.toInt 
        |> Result.map (\i -> subtractAll2 (acc-i) rest)
        |> Result.withDefault Nothing

          
subtractInPasses startingAcc strings =
  strings
    |> List.map (String.toInt >> Result.toMaybe)
    |> Maybe.combine
    |> Maybe.map (List.foldl (flip (-)) startingAcc)
    
-- Note: the argument is assumed to be correct.
charToDigit : Char -> Int 
charToDigit char =
  Char.toCode char - Char.toCode '0'


reverse : List a -> List a
reverse list =
  List.foldl (::) [] list

map1 : (a -> b) -> List a -> List b
map1 f list =
  let
    step : a -> List b -> List b
    step a acc =
      acc ++ [(f a)]
  in
    List.foldl step [] list
                 
map2 : (a -> b) -> List a -> List b
map2 f list =
  let
    step : a -> List b -> List b
    step a acc =
      (f a) :: acc
  in
    list
      |> List.foldl step []
      |> reverse


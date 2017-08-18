module ToInt.Simple exposing (..)

import Char
import Maybe.Extra as Maybe

-- First tail-recursive version.
toIntLike: Int -> String -> Int
toIntLike acc characters = 
  case String.uncons characters of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      let
        newSoFar = 10 * acc + charToDigit currentChar
      in 
        toIntLike newSoFar newRemainingString

-- extract the "body of the loop"          
toIntLikeStep : Char -> Int -> Int
toIntLikeStep currentChar acc = 
  10 * acc + charToDigit currentChar

toIntLikePlus : (Char -> Int -> Int) -> Int -> String
          -> Int
toIntLikePlus f acc characters =
  case String.uncons characters of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      toIntLikePlus f (f currentChar acc) newRemainingString

-- Generalize from `Int` accumulator.        
moreGeneral : (Char -> acc -> acc) -> acc -> String
            -> acc
moreGeneral f acc characters =
  case String.uncons characters of 
    Nothing -> 
      acc
    Just (currentChar, newRemainingString) ->
      moreGeneral f (f currentChar acc) newRemainingString

-- Similar function for `List`.        
listGeneral : (any -> acc -> acc) -> acc -> List any
             -> acc
listGeneral f acc rest =
  case rest of 
    [] -> 
      acc
    current :: newRest ->
      listGeneral f (f current acc) newRest


-- Two types of recursion        
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

factorialWithHelper originalN =
  let 
    helper acc n = 
      if n <= 1 then
        acc
      else
        helper (n * acc) (n - 1)
  in
    helper 1 originalN



-- subtractAll with strings

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

subtractFold : Int -> List String -> Maybe Int      
subtractFold acc strings =
  let
    helper string acc =
      string
        |> String.toInt
        |> Result.toMaybe
        |> Maybe.map (\int -> acc - int)

    step string maybeAcc =
      Maybe.andThen (helper string) maybeAcc
  in
    List.foldl step (Just acc) strings
           
subtractInPasses startingAcc strings =
  strings
    |> List.map (String.toInt >> Result.toMaybe)
    |> Maybe.combine
    |> Maybe.map (List.foldl (flip (-)) startingAcc)
    



-- A function that doesn't have laziness available
withIndices : List a -> List (Int, a)
withIndices list =
  let
    counts = List.range 0 (List.length list)
  in
    List.map2 (,) counts list

       

-- Don't call this!
forever : (a -> a) -> a -> List a
forever f seed =
  seed :: forever f (f seed)


-- We're pretending this is a lazy infinite list.
integers = [0, 1, 2, 3, 4, 5]      

withIndicesLazily : List a -> List (Int, a)
withIndicesLazily list =
  List.map2 (,) integers list
      
subtractAllLazy : number -> List number -> number
subtractAllLazy startingValue subtrahends =
  List.foldl (flip (-)) startingValue subtrahends



-- Helper functions not mentioned in the text    

-- Note: the argument is assumed to be correct.
charToDigit : Char -> Int 
charToDigit char =
  Char.toCode char - Char.toCode '0'


    

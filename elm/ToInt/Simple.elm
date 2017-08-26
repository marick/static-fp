module ToInt.Simple exposing (..)

import Char

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
factorial : Int -> Int
factorial n =
  if n <= 1 then
    1
  else
    (*) n (factorial (n - 1))

tailFactorial : Int -> Int -> Int
tailFactorial acc n =
  if n <= 1 then
    acc
  else
    tailFactorial (n * acc) (n - 1)

factorialWithHelper : Int -> Int
factorialWithHelper originalN =
  let 
    helper acc n = 
      if n <= 1 then
        acc
      else
        helper (n * acc) (n - 1)
  in
    helper 1 originalN


-- Helper functions not mentioned in the text    

-- Note: the argument is assumed to be correct.
charToDigit : Char -> Int 
charToDigit char =
  Char.toCode char - Char.toCode '0'


    

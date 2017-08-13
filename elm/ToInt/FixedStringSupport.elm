module ToInt.FixedStringSupport exposing (..)

import Char
import Maybe.Extra as Maybe

type Sign = Positive | Negative

applySign : Sign -> Int -> Int
applySign sign i =
  case sign of
    Positive -> i
    Negative -> negate i

charToDigit : Char -> Maybe Int 
charToDigit char =
  case Char.isDigit char of
    True -> Just <| Char.toCode char - Char.toCode '0'
    False -> Nothing

tupleAndThenSecond : (second -> Maybe newSecond)
                   -> (first, second)
                   -> Maybe (first, newSecond)
tupleAndThenSecond f (first, second) =
  case f second of
    Nothing -> Nothing
    Just newSecond -> Just (first, newSecond)

type alias Length = Int
  
componentize : Length -> String
             -> Maybe ( Sign , List Int, Maybe Int )
componentize maxLength candidate =
  let
    toSignPair : String -> Maybe (Sign, String)
    toSignPair original=
      case String.uncons original of
        Nothing ->        Nothing
        Just ('-', "") -> Nothing
        Just ('+',  "") -> Nothing
        Just ('-', rest) ->  Just (Negative, rest)
        Just ('+', rest) ->  Just (Positive, rest)
        Just (_ , rest) -> Just (Positive, candidate)

    provideChars : (Sign, String) -> (Sign, List Char)
    provideChars = 
      Tuple.mapSecond String.toList

    digitize : (Sign, List Char) -> Maybe (Sign, List Int)
    digitize =
      tupleAndThenSecond (Maybe.traverse charToDigit)

    toFinalForm : (Sign, List Int) ->  Maybe (Sign, List Int, Maybe Int)
    toFinalForm (sign, digits) = 
      let
        safeLength = maxLength - 1
        safePart = List.take safeLength digits
        lastPart = List.drop safeLength digits
      in 
        case lastPart of
          [] -> Just ( sign, safePart, Nothing )
          [d] -> Just ( sign, safePart, Just d )
          _ -> Nothing
        

    shortEnough : (Sign, String) -> Bool
    shortEnough (_, s) = 
      String.length s <= maxLength
  in
    candidate
      |> toSignPair
      |> Maybe.filter shortEnough -- actually an optimization
      |> Maybe.map provideChars
      |> Maybe.andThen digitize
      |> Maybe.andThen toFinalForm

    
calculate : ( Sign , List Int, Maybe Int ) -> Maybe Int
calculate (sign, safePart, dangerDigit) =
  let
    multiply soFar digits =
      case digits of
        first :: rest -> multiply (soFar * 10 + first) rest
        [] -> soFar

    safeResult =
      multiply 0 safePart

    fullyMultiplied =
      case (compare safeResult maxPrefix, sign, dangerDigit) of
        (GT, _       , _) -> Nothing
        (EQ, Positive, Just 9) -> Nothing
        (EQ, Positive, Just 8) -> Nothing
        (EQ, Negative, Just 9) -> Nothing
        (EQ, _       , Just digit) -> Just (10 * safeResult + digit)
        (_ , _       , Just digit) -> Just (10 * safeResult * digit)
        (_ , _       , Nothing)    -> Just safeResult
  in
    fullyMultiplied
      |> Maybe.map (applySign sign)
         
toIntMaxInt : Int
toIntMaxInt =    2147483647

toIntMinInt : Int
toIntMinInt =   -2147483648

maxPrefix : Int
maxPrefix   =    214748364

maxLength : Int                 
maxLength = 10
            
err : String -> Result String Int
err original =
  Err ("could not convert string '" ++ original ++ "' to an Int")
 

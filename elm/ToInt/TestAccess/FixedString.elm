module ToInt.TestAccess.FixedString exposing
  ( componentize
  , calculate
  , err
  , maxLength

  -- available to tests
  , Sign(..)
  , toIntMinInt
  , toIntMaxInt
  , charToDigit
  , multiplyFully
  )

import Char
import Maybe.Extra as Maybe

type Sign = Positive | Negative
type alias Length = Int

-- main functions  

componentize : Length -> String
             -> Maybe ( Sign , List Int, Maybe Int )
componentize maxLength candidate =
  let
    toSignPair : String -> Maybe (Sign, String)
    toSignPair original =
      case String.uncons original of
        Nothing ->          Nothing
        Just ('-', "") ->   Nothing
        Just ('+',  "") ->  Nothing
        Just ('-', rest) -> Just (Negative, rest)
        Just ('+', rest) -> Just (Positive, rest)
        Just (_ , rest) ->  Just (Positive, candidate)

    provideChars : (Sign, String) -> (Sign, List Char)
    provideChars = 
      Tuple.mapSecond String.toList

    digitize : (Sign, List Char) -> Maybe (Sign, List Int)
    digitize tuple =
      tuple 
        |> Tuple.mapSecond (Maybe.traverse charToDigit)
        |> combineSecond

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

    isShortEnough : (Sign, String) -> Bool
    isShortEnough (_, s) = 
      String.length s <= maxLength
  in
    candidate
      |> toSignPair
      |> Maybe.filter isShortEnough -- actually an optimization
      |> Maybe.map provideChars
      |> Maybe.andThen digitize
      |> Maybe.andThen toFinalForm

calculate : ( Sign , List Int, Maybe Int ) -> Maybe Int
calculate (sign, safeDigits, tenthDigit) =
  let
    step digit acc =
      acc * 10 + digit 
  in
    safeDigits -- caller ensures overflow is impossible
      |> List.foldl step 0 
      |> multiplyFully sign tenthDigit
      |> Maybe.map (applySign sign)

multiplyFully : Sign -> Maybe Int -> Int -> Maybe Int
multiplyFully sign tenthDigit partialResult =
  case (compare partialResult maxPrefix, sign, tenthDigit) of
    (_ , _       , Nothing)    -> Just partialResult
    (GT, _       , Just digit) -> Nothing
    (EQ, _       , Just 9)     -> Nothing
    (EQ, Positive, Just 8)     -> Nothing
    (_ , _       , Just digit) -> Just (10 * partialResult + digit)
                               -- Sigh. The above would overflow a
                               -- 32-bit integer. 

err : String -> Result String Int
err original =
  Err ("could not convert string '" ++ original ++ "' to an Int")

-- others

         
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

combineSecond : (first, Maybe second) -> Maybe (first, second)
combineSecond (unchanged, maybe) =
  Maybe.map ((,) unchanged) maybe

         
toIntMaxInt : Int
toIntMaxInt =    2147483647

toIntMinInt : Int
toIntMinInt =   -2147483648

maxPrefix : Int
maxPrefix   =    214748364

maxLength : Int                 
maxLength = 10
            

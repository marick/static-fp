module ToInt.TestAccess.Sign exposing (componentize)

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
    toSignPair original=
      case String.uncons original of
        Nothing ->        Nothing
        Just ('-', "") -> Nothing
        Just ('+',  "") -> Nothing
        Just ('-', rest) ->  Just (Negative, rest)
        Just ('+', rest) ->  Just (Positive, rest)
        Just (_ , rest) -> Just (Positive, candidate)

    toFinalForm : Sign -> List Int ->  Maybe (Sign, List Int, Maybe Int)
    toFinalForm sign digits = 
      let
        safeLength = maxLength - 1
        safePart = List.take safeLength digits
        lastPart = List.drop safeLength digits
      in 
        case lastPart of
          [] -> Just ( sign, safePart, Nothing )
          [d] -> Just ( sign, safePart, Just d )
          _ -> Nothing
  in
    case toSignPair candidate of
      Nothing ->
        Nothing
      Just (sign, string) ->
        String.toList string
          |> Maybe.traverse charToDigit
          |> Maybe.andThen (toFinalForm sign)

         
charToDigit : Char -> Maybe Int 
charToDigit char =
  case Char.isDigit char of
    True -> Just <| Char.toCode char - Char.toCode '0'
    False -> Nothing

combineSecond : (first, Maybe second) -> Maybe (first, second)
combineSecond (unchanged, maybe) =
  Maybe.map ((,) unchanged) maybe


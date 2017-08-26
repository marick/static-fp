module ToInt.LessSimple exposing (..)

import Maybe.Extra as Maybe


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
           
subtractInPasses : Int -> List String -> Maybe Int      
subtractInPasses startingAcc strings =
  strings
    |> List.map (String.toInt >> Result.toMaybe)
    |> Maybe.combine
    |> Maybe.map (List.foldl (flip (-)) startingAcc)
    

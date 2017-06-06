module IvArchitecture.Common.FloatString exposing
  ( FloatString
  , fromFloat
  , fromString
  , asString

  -- The following are really only useful for testing.
  , isValid
  , isEmpty
  )

import Maybe.Extra as Maybe
import Result.Extra as Result


type FloatStringTag = Empty | Valid

type alias FloatString =
  { tag : FloatStringTag
  , value : String
  }

isEmpty : FloatString -> Bool
isEmpty {tag} =
  tag == Empty

isValid : FloatString -> Bool
isValid {tag} =
  tag == Valid

asString : FloatString -> String
asString {value} = value
  
fromFloat : Float -> FloatString
fromFloat float =
  FloatString Valid (toString float)

fromString : FloatString -> String -> FloatString
fromString default string =
  let
    trimmed =
      String.trim string

    tagWhen predicate tag =
      case predicate trimmed of
        True -> Just tag
        False -> Nothing

    possibleTag =
      tagWhen (String.toFloat >> Result.isOk) Valid
        |> Maybe.orElse (tagWhen String.isEmpty Empty)
  in
    case possibleTag of
      Nothing -> default
      Just tag -> FloatString tag string

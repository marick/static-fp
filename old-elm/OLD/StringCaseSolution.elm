module Lens.Try3.Exercises.StringCaseSolution exposing (..)

import Lens.Try3.Lens as Lens
import Tagged exposing (Tagged(..))


dawn1 : Lens.OneCase String String
dawn1 =
  let 
    get big =
      case big == "dawn" of
        True -> Just big
        False -> Nothing
  in
    Lens.oneCase get identity
dawn2 : Lens.OneCase String String
dawn2 =
  let 
    get big =
      if String.toUpper big == "DAWN" then
        Just big
      else
        Nothing
  in
    Lens.oneCase get identity

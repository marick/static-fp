module Lens.Motivation.OneCase.FavoriteWordSolution exposing (..)

import Lens.Try3.Lens as Lens

dawn1 : Lens.OneCase String String
dawn1 =
  let 
    get big =
      case big of
        "dawn" -> Just big
        _ -> Nothing
    set =
      identity
  in
    Lens.oneCase get set


dawn2 : Lens.OneCase String String
dawn2 =
  let 
    get big =
      if String.toUpper big == "DAWN" then
        Just big
      else
        Nothing

    set =
      identity
  in
    Lens.oneCase get set
      

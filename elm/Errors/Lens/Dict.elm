module Errors.Lens.Dict exposing
  ( errorLens
  )

import Lens.Try3.Dict as Dict
import Errors.Lens.Error as Lens
import Dict exposing (Dict)

errorLens : comparable -> Lens.Error String (Dict comparable val) val
errorLens key =
  let
    msg _ =
      "The Dict has no `" ++ toString key ++ "` key."
  in
    Dict.humbleLens key |> Lens.humbleToError msg


  

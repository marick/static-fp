module Lens.Try3.Array exposing
  ( lens
  )

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

errorLens : Int -> Lens.Error String (Array val) val
errorLens index =
  let
    msg _ =
      "The Array has no element " ++ toString index ++ "."
  in
    lens index |> Compose.humbleToError msg



module Lens.Try3.Array exposing
  ( lens
  -- , alarmistLens
  )

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

x = Debug.log "======== TODO: " "alarmistLens"
-- alarmistLens : Int -> Lens.Alarmist String (Array val) val
-- alarmistLens index =
--   let
--     msg _ =
--       "The Array has no element " ++ toString index ++ "."
--   in
--     lens index |> Compose.humbleToAlarmist msg



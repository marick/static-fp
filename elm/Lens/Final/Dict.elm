module Lens.Final.Dict exposing
  ( lens
  , humbleLens
  , alarmistLens
  )

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Compose
import Dict exposing (Dict)

{- This lens can add keys or delete them. -}

lens : comparable -> Lens.Upsert (Dict comparable val) val
lens key =
  Lens.upsert (Dict.get key) (Dict.insert key) (Dict.remove key)

humbleLens : comparable -> Lens.Humble (Dict comparable val) val
humbleLens key =
  lens key |> Compose.upsertToHumble

alarmistLens : comparable -> Lens.Alarmist (Dict comparable val) val
alarmistLens key =
  Lens.alarmist key (Dict.get key) (Dict.insert key)

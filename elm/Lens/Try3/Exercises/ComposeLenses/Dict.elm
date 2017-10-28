module Lens.Try3.Exercises.ComposeLenses.Dict exposing
  ( lens
  )

-- This file has a predefined lens for the Compose exercise.

import Lens.Try3.Exercises.Compose as Lens
import Dict exposing (Dict)

lens : comparable -> Lens.Upsert (Dict comparable val) val
lens key =
  Lens.upsert (Dict.get key) (Dict.insert key) (Dict.remove key)


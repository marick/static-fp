module Lens.Try3.Dict exposing
  ( lens
  )

import Lens.Try3.Lens as Lens
import Dict exposing (Dict)

lens : comparable -> Lens.Upsert (Dict comparable val) val
lens key =
  Lens.upsert (Dict.get key) (Dict.insert key) (Dict.remove key)


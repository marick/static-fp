module Choose.Common.Dict exposing
  ( valueAt
  )

import Choose.MaybePart as MaybePart exposing (MaybePart)
import Dict exposing (Dict)

valueAt : comparable -> MaybePart (Dict comparable val) val
valueAt key = 
  MaybePart.make (Dict.get key) (Dict.insert key)

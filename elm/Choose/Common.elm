module Choose.Common exposing (..)

import Choose.MaybePart as MaybePart exposing (MaybePart)

import Dict exposing (Dict)

dict : comparable -> MaybePart (Dict comparable val) val
dict key = 
  MaybePart.make (Dict.get key) (Dict.insert key)


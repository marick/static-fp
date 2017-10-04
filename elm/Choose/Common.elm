module Choose.Common exposing (..)

import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Keyed as Keyed exposing (Keyed)

import Dict exposing (Dict)

dict : comparable -> MaybePart (Dict comparable val) val
dict key = 
  MaybePart.make (Dict.get key) (Dict.insert key)

keyedDict : comparable -> Keyed (Dict comparable val) val
keyedDict key = 
  Keyed.make (Dict.get key) (Dict.insert key) Dict.empty


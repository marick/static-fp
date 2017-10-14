module Lens.Try2.UpsertLensTest exposing (..)

import Lens.Try2.UpsertLens as ULens exposing (UpsertLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)


-- Note: the getters and setters are tested via the laws
update =
  let
    lens = ULens.dict "key"
  in
    describe "update for UpsertLenses"
      [ equal_ (ULens.update lens negate
                  (Dict.singleton "key" 1))
                  (Dict.singleton "key" -1)
      , equal_ (ULens.update lens negate
                  (Dict.singleton "NOTKEY" 1))
                  (Dict.singleton "NOTKEY" 1)
      ]

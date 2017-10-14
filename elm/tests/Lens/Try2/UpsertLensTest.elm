module Lens.Try2.UpsertLensTest exposing (..)

import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)


-- Note: the getters and setters are tested via the laws
update =
  let
    lens = UpsertLens.dict "key"
  in
    describe "update for UpsertLenses"
      [ equal_ (UpsertLens.update lens negate
                  (Dict.singleton "key" 1))
                  (Dict.singleton "key" -1)
      , equal_ (UpsertLens.update lens negate
                  (Dict.singleton "NOTKEY" 1))
                  (Dict.singleton "NOTKEY" 1)
      ]


dictsObeyLensLaws =
  let
    whole = Dict.singleton "key" "OLD"
    lens = UpsertLens.dict "key"
  in
    describe "Dict and lens laws"
      [ Laws.lens "Just"
          (UpsertLens.ops lens) whole (Just "NEW") (Just "overwritten")
      , Laws.lens "Nothing"
          (UpsertLens.ops lens) whole Nothing (Just "overwritten")
      ]    
      

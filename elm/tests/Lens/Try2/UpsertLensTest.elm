module Lens.Try2.UpsertLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)
import List.Extra as List

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
    lens = UpsertLens.dict "key"
  in
    describe "dict obeys lens laws" <|
      List.append
        (checkLaws lens (Just "OLD") (Dict.singleton "key" "OLD"))
        (checkLaws lens Nothing (Dict.empty))



-- Support


unwrap (T.UpsertLens lens) = lens

checkLaws wrappedLens original whole =
  let
    maybes x =
      [Nothing, Just x]

    partsTuples =
      List.lift2 (,) (maybes Laws.overwritten) (maybes Laws.new)

    tupleToRecord (overwritten, new) =
      { original = original
      , new = new
      , overwritten = overwritten
      }

    oneCheck tuple =
      Laws.lens
        (toString (original, tuple))
        (unwrap wrappedLens)
        whole
        (tupleToRecord tuple)
  in
    List.map oneCheck partsTuples
    
    
      

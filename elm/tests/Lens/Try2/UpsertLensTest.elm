module Lens.Try2.UpsertLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)
import Lens.Try2.Lens as Lens

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)
import List.Extra as List
import Lens.Try2.Tuple2 as Tuple2

-- Note: the getters and setters are tested via the laws
update : Test
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

-- Law tests
-- Note: these are for expressions that *produce* UpsertLenses.

      
dictsObey : Test
dictsObey =
  let
    lens = UpsertLens.dict "key"
  in
    describe                                             "dict obeys lens laws"
      (List.append
        (laws lens   (Just original)  (Dict.singleton "key" original))
        (laws lens   Nothing          (Dict.empty)))

lensPlusUpsertObeys : Test 
lensPlusUpsertObeys =
  let
    lens =
      Tuple2.second
        |> Lens.andThenUpsert (UpsertLens.dict "key")
  in
    describe                                             "Lens+Upsert"
      (List.append
        (laws lens   (Just original)  (1.3, (Dict.singleton "key" original)))
        (laws lens   Nothing          (1.3, (Dict.empty))))

-- Support

original = 1    -- This marks the original value at the lens's focus,
                -- provided there is such a value.

laws : UpsertLens whole Int -> Maybe Int -> whole -> List Test
laws (T.UpsertLens lens) original whole =
  let
    maybes x =
      [Nothing, Just x]

    partsTuples =
      List.lift2 (,) (maybes 0) (maybes 300)

    tupleToRecord (overwritten, new) =
      { original = original
      , new = new
      , overwritten = overwritten
      }

    oneCheck tuple =
      Laws.lens
        (toString (original, tuple))
        lens
        whole
        (tupleToRecord tuple)
  in
    List.map oneCheck partsTuples

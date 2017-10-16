module Lens.Try2.UpsertLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)
import List.Extra as List

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

dictsObeyLensLaws : Test
dictsObeyLensLaws =
  let
    lens = UpsertLens.dict "key"
  in
    describe                                             "dict obeys lens laws" <|
      List.append
        (laws lens   (Just original)  (Dict.singleton "key" original))
        (laws lens   Nothing          (Dict.empty))



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
    
    
      

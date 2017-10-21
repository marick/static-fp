module Lens.Try3.CompositionTest exposing (..)

import Lens.Try3.Lens as Lens exposing (ClassicLens, get, set, update)
import Lens.Try3.Tuple2 as Tuple2

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Laws as Laws
import Dict
import Lens.Try3.Dict as Dict
import Array
import Lens.Try3.Array as Array
import Lens.Try3.Util exposing (..)

compose_classic_with_classic : Test 
compose_classic_with_classic =
  let
    lens = Lens.compose Tuple2.first Tuple2.second
    (original, parts, legal) = classicLawSupport
  in
    describe "lens plus lens"
      [ upt   lens (("",        3), "")
                   (("",       -3), "")
      , legal lens (("", original), "")
      ]


compose_classic_with_upsert : Test 
compose_classic_with_upsert =
  let
    lens = Lens.composeUpsert Tuple2.first (Dict.lens "key")
    (original, parts, legal) = upsertLawSupport
  in
    describe "lens plus upsert"
      [ describe "update"
          [ upt   lens ( (Dict.singleton "key"  3), "")
                       ( (Dict.singleton "key" -3), "")
          , upt   lens ( (Dict.singleton "---"  3), "")
                       ( (Dict.singleton "---"  3), "")
          , upt   lens (  Dict.empty,               "")
                       (  Dict.empty,               "")
          ]
      , describe "dict"
          [ legal lens ( (Dict.singleton "key" original), "")
          , legal lens ( (Dict.singleton "---" original), "")
          ]
      ]


-- compose_upsert_with_classic : Test 
-- compose_upsert_with_classic =
--   let
--     lens = Lens.upsertComposeClassic (Dict.lens "key") Tuple2.first 
--     (original, parts, present, missing) = iffyLawSupport
--   in
--     describe "upsert plus lens"
--       [ describe "update for various common base types (iffy lenses)"
--           [ upt (Dict.singleton "key" (3, ""))   Dict.singleton "key" (-3 "")
--           ]
      
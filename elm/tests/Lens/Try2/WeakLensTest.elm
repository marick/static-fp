module Lens.Try2.WeakLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)
import Lens.Try2.UpsertLens as UpsertLens
import Lens.Try2.Tuple2 as Tuple2

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Array
import Dict


-- Note: the getters and setters are tested indirectly, here and in the laws
update : Test
update =
  let
    lens = WeakLens.array 1
  in
    describe "update for WeakLenses"
      [ equal (WeakLens.update lens negate
                 (Array.fromList [10,  20]))
                 (Array.fromList [10, -20])    "value exists at focus"
      , equal (WeakLens.update lens negate
                  (Array.fromList [10]))
                  (Array.fromList [10])        "no value at focus"
      ]

-- Law tests
-- Note: these are for expressions that *produce* WeakLenses.

arrayObeys : Test
arrayObeys =
  let
    oneElement = Array.fromList [ parts.original ] 
  in
    describe                                   "weaklens laws: arrays"
      [ presentLaws (WeakLens.array 0)   oneElement
      , missingLaws (WeakLens.array 33)  oneElement    "array too short"
      ]

weakPlusWeakObeys : Test
weakPlusWeakObeys =
  let
    oneElement =
      Array.fromList [
         Array.fromList [parts.original]
      ]
    hit = WeakLens.array 0
    miss = WeakLens.array 333
                
    fitsArray = WeakLens.compose   hit  hit
    missOuter = WeakLens.compose   miss hit
    missInner = WeakLens.compose   hit  miss
  in
    describe                                   "weaklens laws: weak+weak"
      [ presentLaws fitsArray oneElement
      , missingLaws missOuter oneElement             "outer array"
      , missingLaws missInner oneElement             "inner array"
      ]

upsertPlusUpsertObeys : Test 
upsertPlusUpsertObeys =
  let
    lens =
      UpsertLens.compose (UpsertLens.dict "key") (UpsertLens.dict "key2")
    lensApplies =
      Dict.singleton "key" (Dict.singleton "key2" parts.original)
    badOuter =
      Dict.empty
    badInner =
      Dict.singleton "key" Dict.empty
  in
    describe                                  "weaklens laws: upsert + upsert"
      [ presentLaws lens lensApplies
      , missingLaws lens badOuter             "bad wrapping dict"
      , missingLaws lens badInner             "bad wrapped dict"
      ]

upsertPlusClassicObeys =
  let
    lens =
      UpsertLens.composeLens (UpsertLens.dict "key") Tuple2.first
    lensApplies =
      Dict.singleton "key" (parts.original, "-")
    badOuter =
      Dict.singleton "NOT" (parts.original, "-")
  in
    describe                                  "weaklens laws: upsert + classic"
      [ presentLaws lens lensApplies
      , missingLaws lens badOuter             "bad wrapping dict"
      ]

-- Support

parts =
  { original = 'o'
  , new = 'n'
  , overwritten = '-'
  }
                           
missingLaws : WeakLens whole Char -> whole -> String -> Test
missingLaws (T.WeakLens fails) whole why =
  describe ("element not present: " ++ why)
    [Laws.weaklens_does_not_create fails whole parts
    ]

  
presentLaws : WeakLens whole Char -> whole -> Test
presentLaws (T.WeakLens found) whole =
  describe "element present"
    [ Laws.weaklens_overwrites found whole parts
    , Laws.weaklens_setting_what_gotten_changes_nothing found whole parts
    , Laws.set_changes_only_the_given_part found whole parts
    ]    

      

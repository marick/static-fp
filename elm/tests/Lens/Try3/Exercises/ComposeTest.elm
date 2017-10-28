module Lens.Try3.Exercises.ComposeTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Dict
import Array

import Lens.Try3.Exercises.Compose as Lens

import Lens.Try3.Exercises.ComposeLenses.Array as Array
import Lens.Try3.Exercises.ComposeLenses.Dict as Dict
import Lens.Try3.Exercises.ComposeLenses.Tuple2 as Tuple2

{-   
     NOTE: Since this is a test file for several exercises, you'll need
     to comment out some tests at first. 
-}

{-                 Conversions       -}

{-      
classic_humble : Test
classic_humble =
  let
    lens = Lens.classicToHumble Tuple2.first
    (original, present, missing) = humbleLawSupport
  in
    describe "lens to humble lens"
      [ upt     lens   ( 3,       "")
                       (-3,       "")
      , present lens   (original, "")
      -- The lens laws for a missing element do not apply.
      ]
-}

{-      
upsert_humble : Test
upsert_humble =
  let
    lens = Lens.upsertToHumble (Dict.lens "key")
    (original, present, missing) = humbleLawSupport
  in
    describe "upsert to humble lens"
      [ upt    lens   (Dict.singleton "key"  3)
                      (Dict.singleton "key" -3)
      , upt    lens    Dict.empty
                       Dict.empty

      , present lens  (Dict.singleton "key" original)
      , missing lens  (Dict.singleton "---" original)   "wrong key"
      , missing lens   Dict.empty                       "empty"
      ]
-}
         
{-                 Combinations       -}

compose_humble_with_humble : Test
compose_humble_with_humble =
  let
    lens = Lens.humbleAndHumble (Array.lens 0) (Array.lens 1)
    (original, present, missing) = humbleLawSupport

    a listOfList =
      List.map Array.fromList listOfList
        |> Array.fromList
  in
    describe "humble + humble"
      [ describe "update"
          [ upt lens   (a [[0, 3]])   (a [[0, -3]])
          , upt lens   (a [[0   ]])   (a [[0    ]])
          , upt lens   (a [[    ]])   (a [[     ]])
          ]
      , describe "laws"
          [ present lens  (a [[' ', original]])
          , missing lens  (a [[' '          ]])       "short"
          , missing lens  (a [              ])        "missing"
          ]
      ]


{-      
compose_upsert_with_classic : Test
compose_upsert_with_classic =
  let
    lens = Lens.upsertAndClassic (Dict.lens "key") (Tuple2.first)
    (original, present, missing) = humbleLawSupport

    d key tuple = Dict.singleton key tuple
  in
    describe "upsert + classic"
      [ describe "update"
          [ upt lens   (d "key" (3, ""))   (d "key" (-3, ""))
          , upt lens   (d "---" (3, ""))   (d "---" ( 3, ""))
          , upt lens   Dict.empty          Dict.empty
          ]
      , describe "laws"
          [ present lens  (d "key" (original, ""))
          , missing lens  (d "---" (original, ""))    "wrong key"
          , missing lens  Dict.empty                  "missing"
          ]
      ]
-}

{-      
compose_classic_with_upsert : Test 
compose_classic_with_upsert =
  let
    lens = Lens.classicAndUpsert Tuple2.first (Dict.lens "key")
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
      , describe "laws" <|
          List.map 
            (upsertLensObeysClassicLaws
               { lens = lens
               , focusMissing = (Dict.empty, "")
               , makeFocus = 
                   \original -> (Dict.singleton "key" original, "")
               })
            (maybeCombinations 1 2 3)
      ]
-}




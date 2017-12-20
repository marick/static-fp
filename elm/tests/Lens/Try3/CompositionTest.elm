module Lens.Try3.CompositionTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Dict
import Array

import Lens.Try3.Compose as Lens
import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result

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
  
compose_classic_with_humble : Test
compose_classic_with_humble =
  let
    lens = Lens.classicAndHumble Tuple2.second (Array.lens 1)
    (original, present, missing) = humbleLawSupport

    whole zeroElt oneElt =
      ( Array.fromList zeroElt
      , Array.fromList oneElt
      )
  in
    describe "classic + humble"
      [ describe "update"
          [ upt lens   (whole [] [])   (whole [] [])
          , upt lens   (whole [] [3])   (whole [] [3])
          , upt lens   (whole [] [5, 3])   (whole [] [5, -3])
          ]
      , describe "laws"
          [ present lens  (whole [] ['a', original])
          , missing lens  (whole [] ['a'])               "short"
          ]
      ]
  

      
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
  

compose_onecase_and_classic : Test
compose_onecase_and_classic =
  let
    lens = Lens.oneCaseAndClassic Result.ok Tuple2.first
    (original, present, missing) = humbleLawSupport
  in
    describe "one-case and classic"
      [ upt lens  (Ok  (3, ""))    (Ok  (-3, ""))
      , upt lens  (Err (3, ""))    (Err ( 3, ""))

      , present lens (Ok (original, ""))
      , missing lens (Err original)   "different case"
      ]
      
      

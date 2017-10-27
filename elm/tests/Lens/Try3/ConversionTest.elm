module Lens.Try3.ConversionTest exposing (..)

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
      ]


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
                     
         
oneCase_humble : Test
oneCase_humble =
  let
    lens = Lens.oneCaseToHumble Result.okLens
    (original, present, missing) = humbleLawSupport
  in
    describe "one-part to humble lens"
      [ upt lens   (Ok 3)  (Ok  -3)
      , upt lens  (Err 3)  (Err  3)

      , present lens (Ok original)
      , missing lens (Err original)   "different case"
      ]
        

module Lens.Try3.ConversionTest exposing (..)

import Lens.Try3.Lens as Lens exposing (ClassicLens, get, set, update)
import Lens.Try3.Tuple2 as Tuple2
import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Laws as Laws
import Dict
import Lens.Try3.Dict as Dict
import Array
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result
import Lens.Try3.Util exposing (..)



classic_iffy : Test
classic_iffy =
  let
    lens = Lens.toIffy Tuple2.first
    (original, present, missing) = iffyLawSupport
  in
    describe "lens to iffy lens"
      [ upt     lens   ( 3,       "")
                       (-3,       "")
      , present lens   (original, "")
      ]


upsert_iffy : Test
upsert_iffy =
  let
    lens = Lens.upsertToIffy (Dict.lens "key")
    (original, present, missing) = iffyLawSupport
  in
    describe "upsert to iffy lens"
      [ upt    lens   (Dict.singleton "key"  3)
                      (Dict.singleton "key" -3)
      , upt    lens    Dict.empty
                       Dict.empty

      , present lens  (Dict.singleton "key" original)
      , missing lens  (Dict.singleton "---" original)   "wrong key"
      , missing lens   Dict.empty                       "empty"
      ]
                     
         
oneCase_iffy : Test
oneCase_iffy =
  let
    lens = Lens.oneCaseToIffy Result.okLens
    (original, present, missing) = iffyLawSupport
  in
    describe "one-part to iffy lens"
      [ upt lens   (Ok 3)  (Ok  -3)
      , upt lens  (Err 3)  (Err  3)

      , present lens (Ok original)
      , missing lens (Err original)   "different case"
      ]
        

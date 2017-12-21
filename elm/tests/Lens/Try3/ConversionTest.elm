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





humble_error : Test
humble_error =
  let
    lens = Lens.humbleToError (toString >> Err) (Dict.humbleLens "key")
    (original, present, missing) = errorLawSupport
  in
    describe "humble to error lens"
      [ negateVia lens  (Dict.singleton "key" 3)  (Dict.singleton "key" -3)
      , negateVia lens  (Dict.singleton "---" 3)  (Dict.singleton "---" 3)
      , negateVia lens   Dict.empty                Dict.empty

      , present (Dict.errorLens "key")   (Dict.singleton "key" original)
      , missing (Dict.errorLens "key")   (Dict.singleton "---" original)  "no key"
      , missing (Dict.errorLens "key")    Dict.empty                      "empty"
      ]

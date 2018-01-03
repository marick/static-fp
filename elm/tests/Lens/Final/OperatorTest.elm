module Lens.Final.OperatorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (..)

import Lens.Final.Operators exposing (..)

import Lens.Final.Tuple2 as Tuple2
import Lens.Final.Dict as Dict
import Lens.Final.Array as Array
import Lens.Final.Result as Result

-- These "tests" are only about trivial errors like typos in the type annotations.

test_cc = Tuple2.first ..>> Tuple2.second
test_cu = Tuple2.first .^>> Dict.upsertLens "key"
test_ch = Tuple2.first .?>> Array.humbleLens 3

test_uc = Dict.upsertLens "key" ^.>> Tuple2.first

test_hh = Array.humbleLens 0 ??>> Array.humbleLens 3
test_hc = Array.humbleLens 0 ?.>> Tuple2.second
          
test_oc = Result.okLens |.>> Tuple2.second
          
test_pp = Dict.pathLens "key" !!>> Array.pathLens 0

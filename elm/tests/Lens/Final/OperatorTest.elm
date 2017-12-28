module Lens.Final.OperatorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (..)

import Lens.Final.Compose.Operators exposing (..)

import Lens.Final.Tuple2 as Tuple2
import Lens.Final.Dict as Dict
import Lens.Final.Array as Array
import Lens.Final.Result as Result

-- These "tests" are only about trivial errors like typos in the type annotations.

test_cc = Tuple2.first ..>> Tuple2.second
test_cu = Tuple2.first .^>> Dict.lens "key"
test_uc = Dict.lens "key" ^.>> Tuple2.first
test_hh = Array.lens 0 ??>> Array.lens 3
test_oc = Result.ok |.>> Tuple2.second

module Lens.Try4.OperatorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try4.Util exposing (..)

import Lens.Try4.Compose.Operators exposing (..)

import Lens.Try4.Tuple2 as Tuple2
import Lens.Try4.Dict as Dict
import Lens.Try4.Array as Array
import Lens.Try4.Result as Result

-- These "tests" are only about trivial errors like typos in the type annotations.

test_cc = Tuple2.first ..>> Tuple2.second
test_cu = Tuple2.first .^>> Dict.lens "key"
test_uc = Dict.lens "key" ^.>> Tuple2.first
test_hh = Array.lens 0 ??>> Array.lens 3
test_oc = Result.ok |.>> Tuple2.second

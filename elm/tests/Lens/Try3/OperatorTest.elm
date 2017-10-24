module Lens.Try3.OperatorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)

import Lens.Try3.Compose.Operators exposing (..)

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array

-- These "tests" are only about trivial errors like typos in the type annotations.

test_cc = Tuple2.first .... Tuple2.second
test_cu = Tuple2.first ...^ (Dict.lens "key")
test_uc = Dict.lens "key" ^... Tuple2.first
test_ii = Array.lens 0 ?..? (Array.lens 3)

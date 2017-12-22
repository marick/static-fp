module Lens.Try3.Exercises.ValidTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (negateVia)

import Lens.Try3.Lens as Lens
import Lens.Try3.Exercises.Valid as Valid
import Lens.Try3.OneCaseTest as OneCase

valid : Test
valid =
  let
    lens = Valid.valid
  in
    describe "valid is a proper OneCase lens"
      [ describe "update"
          [ negateVia lens "3433"    "-3433"
          , negateVia lens "abcd"    "abcd"
          ]
      , describe "laws"
          [ OneCase.get_set lens "3433" 3433
          , OneCase.set_get lens "3433" 3433
          ]
      ]

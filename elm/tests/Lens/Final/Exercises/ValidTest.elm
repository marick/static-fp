module Lens.Final.Exercises.ValidTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (negateVia)

import Lens.Final.Lens as Lens
import Lens.Final.Exercises.Valid as Valid
import Lens.Final.OneCaseTest as OneCase

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

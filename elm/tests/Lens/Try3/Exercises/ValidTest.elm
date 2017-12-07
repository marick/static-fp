module Lens.Try3.Exercises.ValidTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Lens.Try3.Laws as Laws

import Lens.Try3.Lens as Lens
import Lens.Try3.Exercises.Valid as Valid

valid : Test
valid =
  let
    lens = Valid.valid
  in
    describe "valid is a proper OneCase lens"
      [ describe "update"
          [ upt lens "3433"    "-3433"
          , upt lens "abcd"    "abcd"
          ]
      , describe "laws"
          [ Laws.one_case_gotten_part_can_be_set_back lens "3433" 3433
          , Laws.one_case_set_part_can_be_gotten_back lens "3433" 3433
          ]
      ]

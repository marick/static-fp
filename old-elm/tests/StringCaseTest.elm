module Lens.Try3.Exercises.StringCaseTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Lens.Try3.Laws as Laws

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Lens

import Lens.Try3.Exercises.StringCase as StringCase


whyThis = "Because Elm wants something defined in each module"

-- Exercise 1

-- This is commented out because the starting implementation fails

{- 
dawn1 : Test
dawn1 =
  let
    lens = StringCase.dawn1
    upt = uptWith (\s -> s ++ s) lens
  in
    describe "lens that selects 'dawn'"
      [ describe "update"
          [ upt "dawn"        "dawndawn"
          , upt "not-dawn"    "not-dawn"
          , upt "Dawn"        "Dawn"
          ]
      , describe "laws"
        -- whole and part are both "dawn" in successful case
        [ Laws.one_part_gotten_part_can_be_set_back lens "dawn" "dawn"
        , Laws.one_part_set_part_can_be_gotten_back lens "dawn" "dawn" 
        ]
      ]
-} 


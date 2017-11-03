module Lens.Motivation.OneCase.FavoriteWordTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Lens.Try3.Laws as Laws

import Lens.Try3.Lens as Lens

import Lens.Motivation.OneCase.FavoriteWordSolution as Word

{- The usual helper functions for the lens law assumes they're working 
   with types containing a type variable that can be narrowed to an
   arbitrary value. That's not the case here, where the type is
   specifically `String`, so I use wordier versions.
-}

upt lens whole expected comment =
  equal (Lens.update lens String.toUpper whole) expected comment

dawn1 : Test
dawn1 =
  let
    lens = Word.dawn1
  in
    describe "dawn1"
      [ describe "update"
          [ upt lens "dawn"    "DAWN"       "favorite word is modified"
          , upt lens "not"     "not"        "other words are not"
          ]
      , describe "laws"
        [ Laws.one_part_gotten_part_can_be_set_back lens "dawn" "dawn"
        , Laws.one_part_set_part_can_be_gotten_back lens  "dawn" "dawn"
        ]
      ]


dawn2 : Test
dawn2 =
  let
    lens = Word.dawn2
  in
    describe "dawn2"
      [ describe "update"
          [ upt lens "dawn"    "DAWN"           "lowercase"
          , upt lens "DawN"    "DAWN"           "mixed case"
          , upt lens "not"     "not"            "other words left alone"
          ]
      , describe "laws"
        [ describe "lower case" 
            [ Laws.one_part_gotten_part_can_be_set_back lens "dawn" "dawn"
            , Laws.one_part_set_part_can_be_gotten_back lens "dawn" "dawn"
            ]
        , describe "mixed case"
          [ Laws.one_part_gotten_part_can_be_set_back lens "DawN" "DawN"
          , Laws.one_part_set_part_can_be_gotten_back lens "DawN" "DawN"
          ]
        ]
      ]
      

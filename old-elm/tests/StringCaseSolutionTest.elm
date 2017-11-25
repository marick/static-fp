module Lens.Try3.Exercises.StringCaseSolutionTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Lens.Try3.Laws as Laws

import Lens.Try3.Lens as Lens
import Lens.Try3.Exercises.StringCaseSolution as StringCase

-- Exercise 1    

dawn1 : Test
dawn1 =
  let
    {get,set} = StringCase.dawn1
    upt = uptWith String.toUpper StringCase.dawn1
  in
    describe "lens that selects 'dawn'"
      [ describe "update"
          [ upt "dawn"        "DAWN"
          , upt "not-dawn"    "not-dawn"
          , upt "Dawn"        "Dawn"
          ]
      , describe "laws"
          [ describe "they hold in the success case"
              [ equal (get "dawn")   (Just "dawn")   "this defines the success case"

                equal         (set "dawn")         "dawn"    "first law"
              , equal    (get (set "dawn"))  (Just "dawn")   "second law"
              ]
          , describe "the second law continues holds in the failure case"
              [ equal (get "not-dawn")  Nothing     "this defines the failure case"

                
              ]
          ]
      ]


dawn2 : Test
dawn2 =
  let
    lens = StringCase.dawn2
    upt = uptWith (\x -> x ++ x) lens
  in
    describe "lens that selects 'dawn' (disregarding case)"
      [ describe "update"
          [ upt "dawn"        "dawndawn"
          , upt "not-dawn"    "not-dawn"
          , upt "Dawn"        "DawnDawn"
          ]
      , describe "laws"
          [ describe "they hold in the success case"
              [ Laws.one_part_gotten_part_can_be_set_back lens "dAWn" "dAWn"
              , Laws.one_part_set_part_can_be_gotten_back lens "dAWn" "dAWn" 
              ]
          , describe "the second law continues holds in the failure case"
              [ Laws.one_part_set_part_can_be_gotten_back lens "not-dawn" -dawn"
              ]
          ]
      ]
      

module Lens.Final.Exercises.BoxSolutionTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (negateVia)
import Lens.Final.OneCaseTest as OneCase
import Lens.Final.HumbleTest as Humble

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Lens
import Lens.Final.Tuple2 as Tuple2
import Lens.Final.Result as Result

import Lens.Final.Exercises.BoxSolution as Box
  exposing (Box(..), Contents(..))

-- Exercise 3

chainedCases : Test
chainedCases =
  let
    lens = Box.oneCaseAndOneCase Box.contents Box.creamy
    legal = OneCase.legal
  in
    describe "oneCase + oneCase"
      [ describe "update"
          [ negateVia lens (Contents (Creamy 3))   (Contents (Creamy -3))
          , negateVia lens (Contents (Chunky 3))   (Contents (Chunky  3))
          , negateVia lens Empty                   Empty
          ]
      , describe "laws"
          [ legal lens   (Creamy >> Contents)      "round trips work"
          ]
      ]

-- Exercise 4

oneCaseToHumble : Test
oneCaseToHumble =
  let
    lens = Box.oneCaseToHumble Box.creamy
    original = Humble.original
    present = Humble.present
    missing = Humble.missing
  in
    describe "one-case lens to humble lens"
      [ negateVia lens  (Creamy 3)  (Creamy  -3)
      , negateVia lens  (Chunky 3)  (Chunky   3)

      , present lens (Creamy original)
      , missing lens (Chunky original)   "different case"
      ]
      

-- Exercise 5


oneCaseAndClassic : Test
oneCaseAndClassic =
  let
    lens = Box.oneCaseAndClassic Result.okLens Tuple2.first
    original = Humble.original
    present = Humble.present
    missing = Humble.missing
  in
    describe "one-case and classic"
      [ negateVia lens  (Ok  (3, ""))    (Ok  (-3, ""))
      , negateVia lens  (Err (3, ""))    (Err ( 3, ""))

      , present lens (Ok (original, ""))
      , missing lens (Err original)   "different case"
      ]
      

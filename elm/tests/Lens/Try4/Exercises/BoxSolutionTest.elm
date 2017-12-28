module Lens.Try4.Exercises.BoxSolutionTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try4.Util exposing (negateVia)
import Lens.Try4.OneCaseTest as OneCase
import Lens.Try4.HumbleTest as Humble

import Lens.Try4.Lens as Lens
import Lens.Try4.Compose as Lens
import Lens.Try4.Tuple2 as Tuple2
import Lens.Try4.Result as Result

import Lens.Try4.Exercises.BoxSolution as Box
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
    lens = Box.oneCaseAndClassic Result.ok Tuple2.first
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
      

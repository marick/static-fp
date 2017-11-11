module Lens.Try3.Exercises.BoxTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Lens.Try3.Laws as Laws

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Lens
import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Result as Result

import Lens.Try3.Exercises.BoxSolution as Box
  exposing (Box(..), Contents(..))

-- Exercise 1    

chainedCases : Test
chainedCases =
  let
    lens = Box.oneCaseAndOneCase Box.contents Box.creamy
    legal = Laws.onePart
  in
    describe "oneCase + oneCase"
      [ describe "update"
          [ upt lens (Contents (Creamy 3))   (Contents (Creamy -3))
          , upt lens (Contents (Chunky 3))   (Contents (Chunky  3))
          , upt lens Empty                   Empty
          ]
      , describe "laws"
        [ legal lens   (Creamy >> Contents)      "round trips work"
        ]
      ]

-- Exercise 2 

oneCaseTohumble : Test
oneCaseTohumble =
  let
    lens = Box.oneCaseToHumble Box.creamy
    (original, present, missing) = humbleLawSupport
  in
    describe "one-case lens to humble lens"
      [ upt lens  (Creamy 3)  (Creamy  -3)
      , upt lens  (Chunky 3)  (Chunky   3)

      , present lens (Creamy original)
      , missing lens (Chunky original)   "different case"
      ]
      

-- Exercise 3


oneCaseAndClassic : Test
oneCaseAndClassic =
  let
    lens = Box.oneCaseAndClassic Result.ok Tuple2.first
    (original, present, missing) = humbleLawSupport
  in
    describe "one-case and classic"
      [ upt lens  (Ok  (3, ""))    (Ok  (-3, ""))
      , upt lens  (Err (3, ""))    (Err ( 3, ""))

      , present lens (Ok (original, ""))
      , missing lens (Err original)   "different case"
      ]
      

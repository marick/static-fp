module Lens.Try4.Exercises.HeadTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try4.Util as Util exposing (negateVia)

-- CHANGE THE LINE BELOW TO TEST YOUR SOLUTION
import Lens.Try4.Exercises.HeadSolution as Head
import Lens.Try4.HumbleTest as Humble


update : Test
update =
  describe "update"
    [ negateVia Head.lens [3] [-3]
    , negateVia Head.lens [] []
    ]

    
laws : Test
laws =
  let
    original = Humble.original -- value to start with, if focus is present
    present = Humble.present  -- laws that apply when `get` returns a `Just`
    missing = Humble.missing  -- laws that apply when `get` returns `Nothing`
  in
    describe "laws"
      [ present Head.lens   [original]
      , missing Head.lens   [        ]   "short"
      ]
  

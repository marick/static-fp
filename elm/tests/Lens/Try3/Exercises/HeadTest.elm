module Lens.Try3.Exercises.HeadTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia)

-- CHANGE THE LINE BELOW TO TEST YOUR SOLUTION
import Lens.Try3.Exercises.HeadSolution as Head
import Lens.Try3.HumbleTest as Humble


update : Test
update =
  describe "update"
    [ negateVia Head.lens [3] [-3]
    , negateVia Head.lens [] []
    ]

    
laws : Test
laws =
  let
    ( original  -- value to start with, if focus is present
    , present   -- laws that apply when `get` returns a `Just`
    , missing   -- laws that apply when `get` returns `Nothing`
    ) = Humble.lawValues
  in
    describe "laws"
      [ present Head.lens   [original]
      , missing Head.lens   [        ]   "short"
      ]
  

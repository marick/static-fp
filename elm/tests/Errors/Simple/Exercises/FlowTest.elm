module Errors.Simple.Exercises.FlowTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Random

-- Change this to match your source
-- import Errors.Simple.Exercises.Flow as Flow
import Errors.Simple.Exercises.FlowSolution as Flow

type alias Model = Int

always_do : Test
always_do =
  describe "always_do"
    [ equal (Flow.always_do negate (Ok  1))   (Ok  -1)   "success in ..."
    , equal (Flow.always_do negate (Err 1))   (Err -1)   "... both cases."
    ]

whenOk_do : Test
whenOk_do =
  describe "whenOk_do"
    [ equal (Flow.whenOk_do negate (Ok  1))   (Ok  -1)   "only success"
    , equal (Flow.whenOk_do negate (Err 1))   (Err  1)   "failure propagates"
    ]

whenOk_try : Test
whenOk_try =
  let
    succeed = negate >> Just
    fail = always Nothing
  in
    describe "whenOk_try"
      [ equal (Flow.whenOk_try succeed (Ok  1))   (Ok  -1)  "continued success"
      , equal (Flow.whenOk_try fail    (Ok  1))   (Err  1)  "success to failure" 
      , equal (Flow.whenOk_try succeed (Err 1))   (Err  1)  "`succeed` never used"
      , equal (Flow.whenOk_try fail    (Err 1))   (Err  1)  "`fail` never used"
      ]

type Msg = Random Int
      
finishWith : Test
finishWith =
  let
    someCmd = Random.int 0 5 |> Random.generate Random
  in
    describe "finishWith"
    [ equal_ (Flow.finishWith someCmd (Ok  1))   (1, someCmd)
    , equal_ (Flow.finishWith someCmd (Err 1))   (1, Cmd.none)
    ]
  

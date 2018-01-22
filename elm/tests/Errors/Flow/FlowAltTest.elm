module Errors.Flow.FlowAltTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Random

-- Change this to match your source
-- import Errors.Exercises.Flow.FlowAlt as Flow
import Errors.Exercises.Flow.FlowAltSolution as Flow

type alias Model = Int

ok model = { ok = True, model = model }
err model = { ok = False, model = model }           

always_do : Test
always_do =
  describe "always_do"
    [ equal (Flow.always_do negate (ok  1))   (ok  -1)   "success in ..."
    , equal (Flow.always_do negate (err 1))   (err -1)   "... both cases."
    ]

whenOk_do : Test
whenOk_do =
  describe "whenOk_do"
    [ equal (Flow.whenOk_do negate (ok  1))   (ok  -1)   "only success"
    , equal (Flow.whenOk_do negate (err 1))   (err  1)   "failure propagates"
    ]

whenOk_try : Test
whenOk_try =
  let
    succeed = negate >> Just
    fail = always Nothing
  in
    describe "whenOk_try"
      [ equal (Flow.whenOk_try succeed (ok  1))   (ok  -1)  "continued success"
      , equal (Flow.whenOk_try fail    (ok  1))   (err  1)  "success to failure" 
      , equal (Flow.whenOk_try succeed (err 1))   (err  1)  "`succeed` never used"
      , equal (Flow.whenOk_try fail    (err 1))   (err  1)  "`fail` never used"
      ]

type Msg = Random Int
      
finishWith : Test
finishWith =
  let
    someCmd = Random.int 0 5 |> Random.generate Random
  in
    describe "finishWith"
    [ equal_ (Flow.finishWith someCmd (ok  1))   (1, someCmd)
    , equal_ (Flow.finishWith someCmd (err 1))   (1, Cmd.none)
    ]
  

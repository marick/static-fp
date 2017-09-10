module IVFlat.Simulation.ConversionsTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Expect exposing (Expectation)
import IVFlat.Simulation.Conversions as C
import IVFlat.Generic.Measures as M

suite : Test
suite =
  describe "Conversions"
    [ equal 
        (C.toFinalLevel
           (M.litersPerMinute 2.0)
           (M.minutes 2)
           { startingVolume = M.liters 5.5 })
        (M.liters 1.5)
                                              "toFinalLevel"

    , equal 
        (C.toFlowRate
           (M.dripRate 20)
           { dropsPerMil = 2 }) -- 10 mils/second
        (M.litersPerMinute 0.6)
                                              "toFlowRate"
    ]

module IVFinal.Simulation.ConversionsTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import IVFinal.Simulation.Conversions as C
import IVFinal.Generic.Measures as M

(=>) : a -> a -> Expectation
(=>) actual expected =
  Expect.equal actual expected

suite : Test
suite =
  describe "Conversions"
    [ test "toFinalLevel" <| \_ -> 
        C.toFinalLevel (M.litersPerMinute 2.0) (M.minutes 2)
                       { startingVolume = M.liters 5.5 }
          => M.liters 1.5

    , test "toFlowRate" <| \_ ->
        C.toFlowRate (M.dripRate 20) { dropsPerMil = 2 } -- 10 mils/second
          =>  M.litersPerMinute 0.6
    ]

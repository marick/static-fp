module IVFinal.Simulation.ConversionsTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import IVFinal.Simulation.Conversions as C
import IVFinal.Generic.Measures as M

(=>) : a -> a -> Expectation
(=>) actual expected =
  Expect.equal actual expected


toMinutes : Test
toMinutes =
  test "toMinutes" <| \_ -> 
    C.toMinutes (M.hours 2) (M.minutes 3)
      => M.minutes 123

toFinalLevel : Test
toFinalLevel = 
  test "toFinalLevel" <| \_ -> 
    C.toFinalLevel (M.litersPerMinute 2.0) (M.minutes 2)
                   { startingFluid = M.liters 5.5 }
      => M.liters 1.5

toFlowRate : Test
toFlowRate =
  test "toFlowRate" <| \_ ->
    C.toFlowRate (M.dripRate 20) { dropsPerMil = 2 } -- 10 mils/second
      => M.litersPerMinute 0.6

litersOverTime : Test
litersOverTime =
  test "litersOverTime" <| \_ ->
    C.litersOverTime (M.litersPerMinute 3) (M.minutes 2)
      => M.liters 6

        

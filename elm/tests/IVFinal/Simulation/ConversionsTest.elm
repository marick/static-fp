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
    [ test "toMinutes" <| \_ -> 
        C.toMinutes (M.hours 2) (M.minutes 3)
          => M.minutes 123

    , test "toFinalLevel" <| \_ -> 
        C.toFinalLevel (M.litersPerMinute 2.0) (M.minutes 2)
                       { startingVolume = M.liters 5.5 }
          => M.liters 1.5

    , test "toFlowRate" <| \_ ->
        C.toFlowRate (M.dripRate 20) { dropsPerMil = 2 } -- 10 mils/second
          =>  M.litersPerMinute 0.6

    , test "litersOverTime" <| \_ ->
      C.litersOverTime (M.litersPerMinute 3) (M.minutes 2)
        => M.liters 6

    , describe "when the bag runs out"
      (let
         runningTime = M.minutes 10
         bagVolume = M.liters 5
         run excess =
           C.bagRanOutAfter runningTime excess bagVolume
       in
         [ test "edge case" <| \_ ->
             run (M.liters 0) => M.minutes 0
         , test "normal case" <| \_ ->
             run (M.liters 5) => M.minutes 5
         , test "gross excess" <| \_ ->
             run (M.liters 20) => M.minutes 8
         ])
    ]

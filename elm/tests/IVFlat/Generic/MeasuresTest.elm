module IVFlat.Generic.MeasuresTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing ((=>))
import Fuzz
import IVFlat.Generic.Measures as M
import Random

suite : Test
suite =
  describe "Measures"
    [ test "toMinutes" <| \_ -> 
        M.toMinutes (M.hours 2) (M.minutes 3)
          => M.minutes 123

    , test "litersOverTime" <| \_ ->
      M.litersOverTime (M.litersPerMinute 3) (M.minutes 2)
        => M.liters 6

    , describe "fromMinutes"
      [ 
        test "basic" <| \_ ->
          M.fromMinutes (M.minutes 102)
            => (M.hours 1, M.minutes 42)

      , fuzz2 (Fuzz.intRange 0 Random.maxInt) (Fuzz.intRange 0 59)
        "reversible" <|
        \ hourInt minuteInt ->
            let
              (hours, minutes) = (M.hours hourInt, M.minutes minuteInt)
            in
              M.toMinutes hours minutes |> M.fromMinutes
              => (hours, minutes)
      ]

    , describe "friendlyMinutes"
      [ test "0" <| \_ ->
          M.friendlyMinutes (M.minutes 0) => "0 minutes"
      , test "1" <| \_ ->
          M.friendlyMinutes (M.minutes 1) => "1 minute"
      , test "59" <| \_ ->
          M.friendlyMinutes (M.minutes 59) => "59 minutes"

      , test "60" <| \_ ->
          M.friendlyMinutes (M.minutes 60) => "1 hour"
      , test "61" <| \_ ->
          M.friendlyMinutes (M.minutes 61) => "1 hour and 1 minute"
      , test "120" <| \_ ->
          M.friendlyMinutes (M.minutes 120) => "2 hours"
      , test "122" <| \_ ->
          M.friendlyMinutes (M.minutes 122) => "2 hours and 2 minutes"
      ]

      
    , describe "how operations using liters over time"
      [ describe "time required to empty a volume"
          (let
             bagVolume = M.liters 10
             run rate = M.timeRequired rate bagVolume
           in
             [ test "slow" <| \_ ->
                 run (M.litersPerMinute 0.1) => M.minutes 100
             , test "medium" <| \_ ->
               run (M.litersPerMinute 2) => M.minutes 5
             , test "fast" <| \_ ->
               run (M.litersPerMinute 1000) => M.minutes 0
             ])
          
      , describe "what can be accomplised in a given time"
          (let
             run lmp minutes =
               M.litersOverTime (M.litersPerMinute lmp) (M.minutes minutes)
           in
             [
              test "slow" <| \_ ->
                run 0.1 2 => M.liters 0.2
             , test "fast" <| \_ ->
                run 5.0 100 => M.liters 500.0
             ])
           
      , fuzz2 (Fuzz.intRange 1 Random.maxInt) (Fuzz.floatRange 0.1 300.0)
        "reversible" <|
        \ rawMinutes rawLpm ->
            let
              minutes = M.minutes rawMinutes
              lpm = M.litersPerMinute rawLpm
              liters = M.litersOverTime lpm minutes
            in
              M.timeRequired lpm liters => minutes
      ]
    ]

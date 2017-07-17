module IVFlat.Generic.MeasuresTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing (..)
import Fuzz
import IVFlat.Generic.Measures as M
import Random

suite : Test
suite =
  describe "Measures"
    [ check "toMinutes" 
        (M.toMinutes (M.hours 2) (M.minutes 3)) => M.minutes 123

    , check "litersOverTime"
        (M.litersOverTime (M.litersPerMinute 3) (M.minutes 2)) => M.liters 6

    , describe "fromMinutes"
      [ check "basic" (M.fromMinutes <| M.minutes 102) => (M.hours 1, M.minutes 42)

      , fuzz2 (Fuzz.intRange 0 Random.maxInt) (Fuzz.intRange 0 59)
        "reversible" <|
        \ hourInt minuteInt ->
            let
              (hours, minutes) = (M.hours hourInt, M.minutes minuteInt)
            in
              M.toMinutes hours minutes
                |> M.fromMinutes
                |> Expect.equal (hours, minutes)
      ]

    , describe "friendlyMinutes"
        (let
          run val =
           check (toString val) (val |> M.minutes |> M.friendlyMinutes)
         in
           [ run 0 => "0 minutes"
           , run 1 => "1 minute"
           , run 59 => "59 minutes"
           , run 60 => "1 hour"
           , run 61 => "1 hour and 1 minute"
           , run 120 => "2 hours"
           , run 122 => "2 hours and 2 minutes"
           ])

      
    , describe "operations using liters over time"
        [ describe "time required to empty a volume"
          (let
             bagVolume = M.liters 10
             required rate = M.timeRequired (M.litersPerMinute rate) bagVolume
           in
             [ check "slow" (required 0.1) => M.minutes 100
             , check "medium" (required 2) => M.minutes 5
             , check "fast" (required 1000) => M.minutes 0
             ])
          
      , describe "what can be accomplised in a given time"
          (let
             amount rate minutes =
               M.litersOverTime (M.litersPerMinute rate) (M.minutes minutes)
           in
             [ check  "slow" (amount 0.1 2)  => M.liters 0.2
             , check "fast" (amount 5.0 100) => M.liters 500.0
             ])
           
      , fuzz2 (Fuzz.intRange 1 Random.maxInt) (Fuzz.floatRange 0.1 300.0)
        "reversible" <|
        \ rawMinutes rawRate ->
            let
              minutes = M.minutes rawMinutes
              rate = M.litersPerMinute rawRate
              liters = M.litersOverTime rate minutes
            in
              Expect.equal minutes (M.timeRequired rate liters)
      ]
    ]

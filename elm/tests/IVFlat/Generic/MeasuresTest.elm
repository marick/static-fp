module IVFlat.Generic.MeasuresTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestBuilders exposing (..)
import Fuzz
import IVFlat.Generic.Measures as M
import Random


calculatingConstructors : Test
calculatingConstructors =
  describe "toMinutes and friends"
    [ eql (M.toMinutes (M.hours 2) (M.minutes 3))                 <| M.minutes 123
    , eql (M.litersOverTime (M.litersPerMinute 3) (M.minutes 2))  <| M.liters 6
    ]

fromMinute : Test
fromMinute =
  describe "conversions"
    [ eql (M.fromMinutes <| M.minutes 102)      (M.hours 1, M.minutes 42)
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

friendlyMinutes : Test
friendlyMinutes =
  let
    convert = f_1_expected (M.minutes >> M.friendlyMinutes)
  in
    describe "friendlyMinutes"
      [ convert   0       "0 minutes"
      , convert   1       "1 minute"
      , convert  59      "59 minutes"
      , convert  60       "1 hour"
      , convert  61       "1 hour and 1 minute"
      , convert 120       "2 hours"
      , convert 122       "2 hours and 2 minutes"
      ] 

litersAndTime : Test
litersAndTime = 
  describe "operations using liters over time"
    [ describe "time required to empty a volume"
       (let
          bagVolume = M.liters 10
          requiredFor rate = M.timeRequired (M.litersPerMinute rate) bagVolume
        in
          [ equal (requiredFor  0.1)     (M.minutes 100)    "slow"
          , equal (requiredFor    2)     (M.minutes   5)    "medium"
          , equal (requiredFor 1000)     (M.minutes   0)    "less than one minute"
          ])
    
    , describe "what can be accomplished in a given time"
        (let
           amount rate minutes =
             M.litersOverTime (M.litersPerMinute rate) (M.minutes minutes)
         in
           [ eql  (amount 0.1 2)     <|  M.liters 0.2     
           , eql  (amount 5.0 100)   <|  M.liters 500.0   
           ])
           
      , fuzz2 (Fuzz.intRange 1 Random.maxInt) (Fuzz.floatRange 0.1 300.0)
        "reversible" <|
          \ rawMinutes rawRate ->
            let
              minutes = M.minutes rawMinutes
              rate = M.litersPerMinute rawRate
              liters = M.litersOverTime rate minutes
            in
              M.timeRequired rate liters
                |> Expect.equal minutes
      ]

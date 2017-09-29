module Dict.FoldlSolutionTest exposing (..)

import Test exposing (..)
import TestBuilders as Build exposing (eql, equal)

import Dict.FoldlSolution as My
import Dict


compareFor1Arg original new arg =
  eql (original arg) (new arg)

exercise1 = 
  let
    sameResultFor = compareFor1Arg Dict.fromList My.fromList
  in
    describe "exercise 1: fromList"
      [ sameResultFor []
      , sameResultFor [(1, "one"), (2, "two")]

      , equal (Dict.fromList [(1, "1"), (1, "one")])
              (Dict.fromList [(1, "one")])              "last duplicate wins"

      ]

exercise2 = 
  let
    reversed = Build.f_1_expected My.reverse
  in
    describe "exercise 2: reverse"
      [ reversed Dict.empty Dict.empty
      , reversed (Dict.fromList [( 1, "A"), ( 2, "B")])
                 (Dict.fromList [("A", 1 ), ("B", 2 )])
      ]
      
exercise3 = 
  let
    roundTrip  = Build.f_1_expected         (My.fromList >> My.toList)
    roundTripC = Build.f_1_expected_comment (My.fromList >> My.toList)
  in
    describe "exercise 3: toList"
      [ roundTrip  []  [] 
      , roundTripC [("zero",  "0"), ("three", "3")]
                   [("three", "3"), ("zero",  "0")]   "Note result is sorted by key"
      ]

-- This test is commented out because I can't think of a way to write
-- functions that match the type annotation that *isn't* correct.

-- {-
exercise4 =
  describe "exercise 4: uncurry and curry"
    [ equal (My.uncurry (+)           (1, 2) )  3     "create fn that takes tuple"
    , equal (My.curry   (Tuple.second) 1  2  )  2     "spread tuple into args"
    ]
-- -}


exercise5 =
  let
    dict =         Dict.fromList [("one", 1), ("two", 2)]
    negated =  Dict.fromList [("one", -1), ("two", -2)]
  in
    describe "exercise 5: withValue"
      [ eql (Dict.map (My.withValue negate) dict) negated
      ]


    

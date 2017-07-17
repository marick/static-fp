module TestUtil exposing
  ( (=>)
  , (==>)
  , check
  , randomly
  , randomly2
  )

{- Support for this test notation:

       check "comment" actual => expected
       check "comment" actual ==> predicate
-}

import Test exposing (..)
import Expect
import Fuzz exposing (Fuzzer)

-- This captures the values up to but not including the arrow
type LeftHandSide fuzz1 fuzz2 actual 
  = PlainTest String actual
  | Fuzzing String (Fuzzer fuzz1) (fuzz1 -> actual)
  | Fuzzing2 String (Fuzzer fuzz1) (Fuzzer fuzz2) (fuzz1 -> fuzz2 -> actual)
    
-- check : String -> actual -> LeftHandSide fuzz1 actual 
check = PlainTest

randomly = Fuzzing
randomly2 = Fuzzing2

-- Expect.equal sugar        
(=>) : LeftHandSide fuzz1 fuzz2 actual -> actual -> Test
(=>) lhs expected =
  let
    expect actual = Expect.equal expected actual
  in
    case lhs of 
      PlainTest comment actual ->
        test comment
          (\_ -> expect actual)

    -- Should I rule these out as not making much sense?
      Fuzzing comment fuzzer underTest -> 
        fuzz fuzzer comment
          (\randomlyChosen -> expect (underTest randomlyChosen))

      Fuzzing2 comment fuzzer1 fuzzer2 underTest -> 
        fuzz2 fuzzer1 fuzzer2 comment
          (\random1 random2 -> expect (underTest random1 random2))
            
infixl 0 =>

-- Expect.true sugar        
(==>) : LeftHandSide fuzz1 fuzz2 actual -> (actual -> Bool) -> Test
(==>) lhs checker =
  let
    expect actual =
      Expect.true ("Unexpected result: " ++ toString actual) (checker actual)
  in
    case lhs of
      PlainTest comment actual -> 
        test comment
          (\_ -> expect actual)
      Fuzzing comment fuzzer underTest -> 
        fuzz fuzzer comment
          (\randomlyChosen -> expect (underTest randomlyChosen))
      Fuzzing2 comment fuzzer1 fuzzer2 underTest -> 
        fuzz2 fuzzer1 fuzzer2 comment
          (\random1 random2 -> expect (underTest random1 random2))

infixl 0 ==>



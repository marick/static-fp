module TestUtil exposing
  ( (=>)
  , (==>)
  , check
  )

{- Support for this test notation:

       check "comment" actual => expected
       check "comment" actual ==> predicate
-}

import Test exposing (..)
import Expect

-- This captures the values up to but not including the arrow
type Check a = Check String a
check : String -> a -> Check a
check = Check 

-- Expect.equal sugar        
(=>) : Check a -> a -> Test
(=>) (Check comment actual) expected = 
  test comment
    (\_ -> Expect.equal expected actual)
infixl 0 =>

-- Expect.true sugar        
(==>) : Check a -> (a -> Bool) -> Test
(==>) (Check comment actual) checker =
  let
    failureMessage = toString actual ++ " mismatches"
  in
    test comment
      (\_ -> Expect.true failureMessage (checker actual))
infixl 0 ==>



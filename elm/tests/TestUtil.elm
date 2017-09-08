module TestUtil exposing
  ( (=>)
  , (==>)
  , check
  , randomly
  , randomly2

  , equal, equalsd
  , equal2
  , equal3
  , constant
  , constant2
  , constant3
  )

import Test exposing (..)
import Expect
import Fuzz exposing (Fuzzer)

{- 

The `equal` family create tests that apply a function to N arguments
and compare the result to the expected value (using
`Expect.equal`). The test's comment is the last argument. That makes
it easier to align tests in a tabular form.

A typical use:

    allValues =
      let
        when = TestUtil.equal3 functionUnderTest
      in
        describe "allValues is all or nothing"
          [ when ("1",   "2", "3") (just 1 2 3)   "every field is valid"
          , when ("1.5", "0", "3") (just 1.5 0 3) "hours can be 0 if minutes are not"
          ...

The `equalsd` family is the same, except that no comment is
required. Instead, the comment is generated from the argument list.

The `constant` family is used when multiple test cases all have the
same expected value.

A typical use:

    isFormIncomplete : Test
    isFormIncomplete = 
      let
        incomplete = TestUtil.constant3 functionUnderTest True
        complete = TestUtil.constant3 functionUnderTest  False
      in
        describe "isFormIncomplete"
          [ -- no need to sample all the reasons the form is incomplete
            incomplete ("OOPS", "2", "3")   "bad drip rate, for example"
    
          , complete ("1", "2", "3")        "every field has a valid value"
          , complete ("1.5", "0", "3")      "it's OK for hours to be 0"
          , complete ("1", "2", "0")        "it's OK for minutes to be 0"
          ]
-}    



equal f arg1 expected comment =
  test comment <|
    \_ ->
      f arg1 |> Expect.equal expected

equalsd f arg1 expected =
  test (toString arg1) <|
    \_ ->
      f arg1 |> Expect.equal expected

equal2 f ((arg1, arg2) as all) expected comment =
  test comment <|
    \_ ->
      f arg1 arg2 |> Expect.equal expected

equal3 f (arg1, arg2, arg3) expected comment =
  test comment <|
    \_ ->
      f arg1 arg2 arg3 |> Expect.equal expected

constant f alwaysExpected arg1 comment =
  test comment <|
    \_ ->
      f arg1 |> Expect.equal alwaysExpected
  
constant2 f alwaysExpected (arg1, arg2) comment =
  test comment <|
    \_ ->
      f arg1 arg2 |> Expect.equal alwaysExpected
  
constant3 f alwaysExpected (arg1, arg2, arg3) comment =
  test comment <|
    \_ ->
      f arg1 arg2 arg3 |> Expect.equal alwaysExpected

  
















{- Support for this test notation:

       check "comment" actual => expected
       check "comment" actual ==> predicate
-}

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



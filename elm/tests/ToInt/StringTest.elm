module ToInt.StringTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)

toInt_valid : Test
toInt_valid =
  describe "toInt: valid strings"
    [ valid "positive number" "123" 123
    ]


toInt_invalid : Test
toInt_invalid =
  describe "toInt: invalid strings"
    [ bogus "empty string" ""
    ]

-- Test support

-- Shorthand for tests tests. Checker-makers are below that.

{- `valid "test comment" "3737" 3737`

Create a test that `toInt` converts the input to
a correct integer.
-}
valid : String -> String -> Int -> Test
valid comment input expected =
  test comment <|
    \_ -> 
      String.toInt input
        |> Expect.all
           [ ok expected
           , expectSameString input
           ]

{- `bogus "test comment" "abc"`

Create a test that `toInt` converts the input to an `Err`
with the usual error message
-}
bogus : String -> String -> Test
bogus comment input =
  test comment <|
    \_ -> 
      String.toInt input |> err input

{- Like `valid` but only check if the right integer is received, 
   not how that integer stringifies.
-}
validValue : String -> String -> Int -> Test
validValue comment input expected =
  test comment <|
    \_ -> 
      String.toInt input |> ok expected
           

----
        
{- Create checker that expects an `Ok` with the given expected value
-}
ok : any -> (Result err any -> Expectation)
ok expected = Expect.equal (Ok expected)

{- Create a checker that expects an `Err` with the normal `toInt`
   error string (constructed from the original input)
-}
err : String -> (Result String value -> Expectation)
err original =
  let
    expectedMessage = "could not convert string '" ++ original ++ "' to an Int"
  in
    Expect.equal (Err expectedMessage)

{- Create a checker that expects the `Ok` result from `toInt` to
   stringify to the original test input.
   match 
-}
expectSameString : String -> (Result err ok -> Expectation)
expectSameString original result =
  case result of
    Ok val ->
      toString val |> Expect.equal original

    Err _ ->
      Expect.fail ("result " ++ toString result ++ "should not be an Err.")




module ToInt.FixedStringTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import ToInt.FixedString as Fixed 
import ToInt.FixedStringSupport as Fixed exposing (Sign(..))

toInt_valid : Test
toInt_valid =
  describe "toInt: valid strings"
    [ valid "positive number" "123" 123
    , valid "negative number" "-123" -123
    , valid "zero" "0" 0 
      
    , validValue "alternate positive format" "+123" 123
    , validValue "alternate positive format used on zero" "+0" 0
    ]

maxBiggerFirst       = "3000000000"
maxBiggerPenultimate = "2147483650"                   
maxPrefix            = "214748364"
maxIntString   = maxPrefix ++ "7"
tooPositive    = maxPrefix ++ "8"
tooPositiveToo = maxPrefix ++ "9"
wayTooPositive = maxPrefix ++ "70"

minBiggerFirst       = "-3000000000"
minBiggerPenultimate = "-2147483650"                   
minPrefix            = "-214748364"                 
minIntString     = minPrefix ++ "8"
tooNegative      = minPrefix ++ "9"
wayTooNegative   = minPrefix ++ "80"

toInt_boundaries : Test
toInt_boundaries =
  describe "toInt: boundary values"
    [ valid "most positive" maxIntString Fixed.toIntMaxInt
    , valid "most negative" minIntString Fixed.toIntMinInt

    , bogus "one beyond maxInt" tooPositive
    , bogus "two beyond maxInt" tooPositiveToo
    , bogus "way beyond maxInt" wayTooPositive
    , bogus "first digit in length 10 string" maxBiggerFirst
    , bogus "penultimate digit is too big" maxBiggerPenultimate

    , bogus "one beyond minInt" tooNegative
    , bogus "way beyond minInt" wayTooPositive
    , bogus "first digit in length 10 negative string" minBiggerFirst
    , bogus "penultimate digit is too negative big" minBiggerPenultimate
    ]

toInt_invalid : Test
toInt_invalid =
  describe "toInt: invalid strings"
    [ bogus "empty string" ""
    , bogus "leading alpha" "a3"
    , bogus "trailing alpha" "3a"
    , bogus "distantly trailing alpha" "3       a"

    , bogus "nothing after negation" "-"
    , bogus "nothing after positive" "+"

    , bogus "extra -" "--3"
    , bogus "extra +" "++3"

    , bogus "leading whitespace" " 3"
    , bogus "trailing whitespace" "3 "
    , bogus "float" "3." -- toFloat would accept this.
    ]

-- Tests for supporting code

charToDigit : Test
charToDigit =
  let
    check = run Fixed.charToDigit
  in
    describe "charToDigit"
      [ check '/' Nothing  -- just below '0' in ASCII
      , check '0' (Just 0)
      , check '1' (Just 1)
      , check '2' (Just 2)
      , check '3' (Just 3)
      , check '4' (Just 4)
      , check '5' (Just 5)
      , check '6' (Just 6)
      , check '7' (Just 7)
      , check '8' (Just 8)
      , check '9' (Just 9)
      , check ':' Nothing  -- just above '9' in ASCII

      , describe "requires utf-16"
         [ check 'π' Nothing ]
      , describe "requires utf-32 (emoji)"
         [ check '🍎' Nothing ]
      ]

componentize : Test
componentize =
  let
    check = run (Fixed.componentize 2)
  in
    describe "split input into convenient pieces, or Nothing"
      [ describe "discovering the Sign"
          [ check "1" <| Just (Positive, [1], Nothing)
          , check "12" <| Just (Positive, [1], Just 2)
          , check "-23" <| Just (Negative, [2], Just 3)
          , check "+34" <| Just (Positive, [3], Just 4)

          , check "" Nothing
          , check "-" Nothing
          , check "+" Nothing
          ]
      , describe "rejection of strings that are too long to possibly work"
          [ check "-123" Nothing
          , check "+123" Nothing
          , check  "123" Nothing
          ]
      ]

-- Because these tests depend on explicit knowledge that
-- the boundaries are around 32-bit numbers, arrange for
-- a failure if that ever changes.
magicNumbers  : Test
magicNumbers =
  concat
    [ test "I have right value for maxint" <| \_ -> 
        Expect.equal maxIntString (toString Fixed.toIntMaxInt)
    ,  test "I have right value for minint" <| \_ -> 
        Expect.equal minIntString (toString Fixed.toIntMinInt)
    ]

-- Util

expectSameString : String -> Result err ok -> Expectation
expectSameString input result =
  case result of
    Err _ ->
      Expect.fail <| "result " ++ toString result ++ "is an Err."

    Ok val ->
      toString val |> Expect.equal input

ok : value -> (Result err value -> Expectation)
ok expected = Expect.equal (Ok expected)

err : String -> (Result String value -> Expectation)
err original =
  let
    expectedMessage = "could not convert string '" ++ original ++ "' to an Int"
  in
    Expect.equal (Err expectedMessage)

        

valid : String -> String -> Int -> Test
valid comment input expected =
  test comment <|
    \_ -> 
      Fixed.toInt input
        |> Expect.all
           [ ok expected
           , expectSameString input
           ]

validValue : String -> String -> Int -> Test
validValue comment input expected =
  test comment <|
    \_ -> 
      Fixed.toInt input |> ok expected


           
bogus : String -> String -> Test
bogus comment input =
  test comment <|
    \_ -> 
      Fixed.toInt input |> err input


run : (a -> b) -> a -> b -> Test
run f input expected =
  test (toString input) <| \_ ->
    f input |> Expect.equal expected



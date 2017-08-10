module ToInt.FixedStringTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import ToInt.FixedString as Fixed



toInt_valid : Test
toInt_valid =
  describe "toInt: valid strings"
    [ valid "positive number" "123" 123
    , valid "negative number" "-123" -123
    , valid "zero" "0" 0 
      
    , validValue "alternate positive format" "+123" 123
    , validValue "alternate positive format used on zero" "+0" 0
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

maxPrefix      = "214748364"
maxIntString   = maxPrefix ++ "7"
tooPositive    = maxPrefix ++ "8"
wayTooPositive = maxPrefix ++ "70"

minPrefix      = "-214748364"                 
minIntString   = minPrefix ++ "8"
tooNegative    = minPrefix ++ "9"
wayTooNegative = minPrefix ++ "80"

toInt_boundaries : Test
toInt_boundaries =
  describe "toInt: boundary values"
    [ valid "most positive" maxIntString Fixed.toIntMaxInt
    , valid "most negative" minIntString Fixed.toIntMinInt

    , bogus "just beyond maxInt" tooPositive
    , bogus "way beyond maxInt" wayTooPositive

    , bogus "just beyond minInt" tooNegative
    , bogus "way beyond minInt" wayTooNegative
    ]

toInt_boundaries_implementation : Test
toInt_boundaries_implementation =
  describe "toInt: special cases of boundary implementation"
    [ describe "positive"
        [ bogus "bad prefix"                ("21474836=" ++ "7")
        , bogus "bad suffix"                ("214748364" ++ "=")
          
                               --            "214748364" ++ "7"
        , bogus "exact prefix, big suffix"  ("214748364" ++ "8")
        , valid "exact prefix, good suffix" ("214748364" ++ "7") 2147483647
        , valid "small prefix"              ("214748363" ++ "9") 2147483639
        , bogus "big prefix, ok suffix"     ("214748365" ++ "0")
        ]

    , describe "negative"
        [ bogus "bad prefix"                ("-21474836=" ++ "7")
        , bogus "bad suffix"                ("-214748364" ++ "=")
          
                               --            "-214748364" ++ "8"
        , bogus "exact prefix, big suffix"  ("-214748364" ++ "9")
        , valid "exact prefix, good suffix" ("-214748364" ++ "8") -2147483648
        , valid "small prefix"              ("-214748363" ++ "9") -2147483639
        , bogus "big prefix, ok suffix"     ("-214748365" ++ "0")
        ]
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
  
    , bogus "leading whitespace" " 3"
    , bogus "trailing whitespace" "3 "
    , bogus "float" "3." -- toFloat would accept this.
    ]

-- Private

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



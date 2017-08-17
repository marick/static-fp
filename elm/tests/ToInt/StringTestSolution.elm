module ToInt.StringTestSolution exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Random

toInt_valid : Test
toInt_valid =
  describe "toInt: valid strings"
    [ valid "positive number" "123" 123
    , valid "negative number" "-123" -123      
    , valid "zero" "0" 0 -- for giggles
      
    , validValue "alternate positive format" "+123" 123
    , validValue "alternate positive format used on zero" "+0" 0

    , valid "max int" (toString Random.maxInt) Random.maxInt
    , valid "min int" (toString Random.minInt) Random.minInt      
    ]


toInt_oddBoundaries : Test
toInt_oddBoundaries =
  describe "boundary values are odd" <|
    -- Because Javascript strings can hold integers larger
    -- than maxInt (2^32), the following works:
    let
      explicitMaxInt =  2147483647        -- for visual comparison
      input =          "2147483647999999"
      expected =        2147483647999999
    in
      [ valid "big" input expected
      , test "I have right value for maxint" <|
        \_ -> 
          Expect.equal explicitMaxInt Random.maxInt
      ]

    {- However, it will also accept values too big to represent
       precisely. 
        
       This one is interesting: it produces the wrong answer!
    
    , valid "wrong!" "21474836479999999999" 21474836479999999999
        
        Ok 21474836480000000000  -- rounded value
        ╷  
        │ Expect.equal
        ╵
        Ok 3028092406290448400  -- don't know why expected value is misprinted.
                                -- (or misread)

      -- The printing of an approximate number is a weird quirk of Javascript,
      -- required by the spec. Past 21 decimal digits, you get this:
  
    , valid "scientific, maaan" "21474836479999999999999" 21474836479999999999999
  
        Ok 2.147483648e+22
        ╷
        │ Expect.equal
        ╵
        Ok 2826378202081919000
    -}
    -- not bothering with very negative values. I've learned enough.

toInt_invalid : Test
toInt_invalid =
  describe "toInt: invalid strings"
    [ bogus "empty string" ""
    , bogus "leading alpha" "a3"
    , bogus "trailing alpha" "3a"
    , bogus "distantly trailing alpha" "3       a"
      
    , bogus "extra -" "--3"
    , bogus "extra +" "++3"

    , bogus "32-bit Unicode" "9999🍎"
  
    {- Another interesting case: 
    
    , bogus "lone -" "-"
    
         Ok NaN
         ╷
         │ Expect.err
         ╵
         Err _
  
     It produces a "not a number" rather than an `Err`.
     The same is true of a "+".
     -}       
  
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
      String.toInt input
        |> Expect.all
           [ ok expected
           , expectSameString input
           ]

validValue : String -> String -> Int -> Test
validValue comment input expected =
  test comment <|
    \_ -> 
      String.toInt input |> ok expected
           
bogus : String -> String -> Test
bogus comment input =
  test comment <|
    \_ -> 
      String.toInt input |> err input



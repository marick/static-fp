module IVBits.StringTestSolution exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Random exposing (maxInt, minInt)

toInt_valid : Test
toInt_valid =
  describe "toInt: valid strings"
    [ valid "positive number" "123" 123
    , valid "negative number" "-123" -123
    , valid "max int" (toString maxInt) maxInt
    , valid "min int" (toString minInt) minInt
      
    , validValue "alternate positive format" "+123" 123
    ]


toInt_oddBoundaries : Test
toInt_oddBoundaries =
  describe "boundary values are odd"
    [ concat <|
        -- It turns out Random.maxInt isn't the biggest int.
        -- The following works, though it's bigger than maxint
        let
          explicitMaxInt =  2147483647        -- for visual comparison
          input =          "2147483647999999"
          expected =        2147483647999999
        in
          [ valid "big" input expected
          , test "I have right value for maxint" <|
              \_ -> 
                Expect.equal explicitMaxInt maxInt
          ]
        
    {- This one is interesting: it produces the wrong answer!
    
    , valid "wrong!" "21474836479999999999" 21474836479999999999
        
        Ok 21474836480000000000
        ╷
        │ Expect.equal
        ╵
        Ok 3028092406290448400
        
      Notice that the `toInt` result (the first number)
      is the input value + 1. Which makes me think the value
      was promoted to a float.
      
      Note also that the expected value shown in the error
      isn't what I typed in the test. Instead, it's a number
      with fewer digits. Unchecked integer overflow?
          
      To provide more evidence that big integers are converted to
      floats, consider this:
  
    , valid "float?" "21474836479999999999999" 21474836479999999999999
  
        Ok 2.147483648e+22
        ╷
        │ Expect.equal
        ╵
        Ok 2826378202081919000
    -}
    ]

toInt_invalid : Test
toInt_invalid =
  describe "toInt: invalid strings"
    [ bogus "empty string" ""
    , bogus "leading alpha" "a3"
    , bogus "trailing alpha" "3a"
    , bogus "distantly trailing alpha" "3       a"
      
    , bogus "extra -" "--3"
    , bogus "extra +" "++3"
  
  
    {- Another interesting case: 
    
    , bogus "lone -" "-"
    
         Ok NaN
         ╷
         │ Expect.err
         ╵
         Err _
  
     It produces a NaN (which is a Float value), wrapped in Ok!

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



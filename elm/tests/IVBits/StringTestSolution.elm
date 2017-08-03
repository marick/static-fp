module IVBits.StringTestSolution exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result
import Random exposing (maxInt, minInt)

toInt_valid : Test
toInt_valid =
  let
    try : String -> String -> Int -> Test
    try comment input expected =
      test comment <|
        \_ -> 
          String.toInt input
            |> Expect.equal (Ok expected)
  in
    describe "toInt_valid"
      [ try "positive number" "123" 123
      , try "negative number" "-123" -123
      , try "alternate positive format" "+123" 123
      , try "max int" (toString maxInt) maxInt
      , try "min int" (toString minInt) minInt

      -- It turns out Random.maxInt isn't the biggest int.
      -- The following works, though it's bigger than maxint
      , concat
          [ try "big" "2147483647999999999" 2147483647999999999
          , test "bigger than maxint" <|
               \_ -> 2147483647999999999 |> Expect.greaterThan maxInt
          ]
      {-
        This one is interesting: it produces the wrong answer!

      , try "wrong!" "21474836479999999999" 21474836479999999999
      
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
        floats, consider this

      , try "float?" "21474836479999999999999" 21474836479999999999999

          Ok 2.147483648e+22
          ╷
          │ Expect.equal
          ╵
          Ok 2826378202081919000
     -}
    ]
          

toInt_invalid : Test
toInt_invalid =
  let
    try comment input =
      test comment <|
        \_ -> 
          String.toInt input |> Expect.err
  in
    describe "toInt_invalid"
      [ test "format of error message" <|
          \_ ->
            String.toInt ""
              |> Expect.equal (Err "could not convert string '' to an Int")
                 
      , describe "what provokes error messages"
          [ try "leading alpha" "a3"
          , try "trailing alpha" "3a"
          , try "distantly trailing alpha" "3       a"
  
          , try "extra -" "--3"
          , try "extra +" "++3"
  
  
          {- Another interesting case: 
  
          , try "lone -" "-"
  
              Ok NaN
              ╷
              │ Expect.err
              ╵
              Err _
  
            It produces a NaN (which is a Float value), wrapped in Ok!
          -}       
  
          , try "leading whitespace" " 3"
          , try "trailing whitespace" "3 "
          , try "float" "3." -- toFloat would accept this.
        ]
    ]

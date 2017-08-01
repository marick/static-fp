module IVBits.StringTest exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result
import Random exposing (maxInt, minInt)

toInt : Test
toInt =
  describe "toInt"
    [ describe "valid strings"
        (let
           run comment input expected =
             test comment <|
                \_ -> 
                  String.toInt input
                    |> Expect.equal (Ok expected)
         in
           [ run "positive number" "123" 123
           , run "negative number" "-123" -123
           , run "alternate positive format" "+123" 123
           , run "max int" (toString maxInt) maxInt
           , run "min int" (toString minInt) minInt

           -- It turns out Random.maxInt isn't the biggest int.
           -- The following works, though it's bigger than maxint
           , concat
             [ run "big" "2147483647999999999" 2147483647999999999
             , test "bigger than maxint" <|
                 \_ -> 2147483647999999999 |> Expect.greaterThan maxInt
             ]
           {-
             , run "wrong!" "21474836479999999999" 21474836479999999999

                  Ok 21474836480000000000
                  ╷
                  │ Expect.equal
                  ╵
                  Ok 3028092406290448400

              This one is interesting: it produces the wrong answer!
              Notice that the `toInt` result (the first number)
              is the input value + 1. Which makes me think the value
              was promoted to a float.

              Note also that the expected value shown in the error
              isn't what I typed in the test. Instead, it's a number
              with fewer digits. Unchecked integer overflow?

              To provide more evidence that big integers are converted to
              floats, consider this

           , run "float?" "21474836479999999999999" 21474836479999999999999

                Ok 2.147483648e+22
                ╷
                │ Expect.equal
                ╵
                Ok 2826378202081919000
           -}
           ])

    , test "format of error message" <|
        \_ ->
          String.toInt ""
            |> Expect.equal (Err "could not convert string '' to an Int")
               
    , describe "what provokes error messages"
        (let
           run comment input =
             test comment <|
                \_ -> 
                  String.toInt input |> Expect.err
         in
           [ run "leading alpha" "a3"
           , run "trailing alpha" "3a"
           , run "distantly trailing alpha" "3       a"

           , run "extra -" "--3"
           , run "extra +" "++3"


           {- Another interesting case: 

           , run "lone -" "-"

               Ok NaN
               ╷
               │ Expect.err
               ╵
               Err _

             It produces a NaN (which is a Float value), wrapped in Ok!
           -}       

           , run "leading whitespace" " 3"
           , run "trailing whitespace" "3 "
           , run "float" "3." -- toFloat would accept this.
           ])
    ]

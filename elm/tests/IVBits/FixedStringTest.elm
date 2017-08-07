module IVBits.FixedStringTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)

-- I find it's too easy to type "String.toInt" instead of what I'm
-- really testing. This might be less error-prone. With luck, the use
-- of the awkward `MUT.toInt` will make misuses more noticeable. 
import IVBits.FixedString as MUT -- "module under test"
import IVBits.FixedStringSupport as Support


classifyTest tag expected input =
  test (input ++ "is " ++ "tag") <| \_ ->
    Support.classify input |> Expect.equal expected

classify : Test
classify =
  describe "support: classifying strings"
    [ describe "bogus values uncaught by String.toInt or masked by our algorithm" <|
        let
          try = classifyTest "bogus" Support.UndetectablyBogus
        in
          [ -- easiest to catch this here
              try ""
          -- not caught by String.toInt
          , try "-"
          , try "+"
          -- algorithm would obscure these
          , try "++3"
          , try "--453"
          ]

    , describe "values that can be given to toInt" <|
        let
          try = classifyTest "ok to pass through" Support.SuitableForToInt 
        in
          [ -- boundary length: "2147483647"
            try                 "99999999"
          , try                "-99999999"
          , try                "+99999999"
            -- just a little paranoia here
          , try                 "3"
          , try                 "+3"
          , try                 "33"
          , try                 "-3"
          , try                 "-33"
          ]

    , describe "values that have too many characters" <|
        let
          try = classifyTest "way too long" Support.TooLong
        in
          [ -- boundary length: "2147483647"
            try                 "10000000000"
          , try                "-10000000000"
          , try                "+10000000000"
          ]
      
    ]






















-- I don't like depending on Random's maxInt and minInt. Those are advertised
-- as being about randomness of results, not about conversions. Just because
-- two responsibilities happen to be satisfied by the same value doesn't mean
-- they should be coupled together.

maxInt =                       2147483647
sameLengthAsMaxInt =           2100000009                                  
pos_bogusPrefix =             "11838188a8"
pos_bogusLast =               "214748364a"
pos_maxIntPlusOne =           "2147483648"
pos_tooManyDigits =           "10000000000"

minInt =       -2147483648


-- pretest: remove leading zeroes.

-- toInt_specialShortStrings : Test
-- toInt_specialShortStrings =
--   describe "toInt: special short strings"
--     [ bogus "empty" ""

--     -- Since 1 and 2 character strings are special, check valid values
--     , valid "one char" "1" 1
--     , valid "one negative char" "-3" -3
--     , valid "two char" "12" 12
--     , valid "two negative char" "-32" -32

--     , bogus "-" "-"
--     , bogus "+" "+"

--     , bogus "--" "--33"
--     , bogus "++" "++44"

--       -- And, for fun, some non-special bogus cases
--     , bogus "one bogus char" "a"
--     , bogus "one bogus negative char" "-a"
--     , bogus "two bogus char" "1a"
--     , bogus "two bogus negative char" "-a2"
--     ]
 

-- toInt_valid : Test
-- toInt_valid = 
--   describe "the types of valid values"
--     [ valid "positive number" "888" 888
--     , valid "negative number" "-123" -123
--     ]

    
-- -- toInt_boundaries : Test
-- -- toInt_boundaries =
-- --   describe "boundary handling"
-- --     [ valid "max int" (toString maxInt) maxInt
-- --     , valid "same length as max int" (toString sameLengthAsMaxInt) sameLengthAsMaxInt
-- -- --    , valid "min int" (toString minInt) minInt

-- --     , bogus "max length, but first N-1 digit is no integer" pos_bogusPrefix
-- --     , bogus "max length, with last digit no integer" pos_bogusLast
-- --     , bogus "max int + 1" pos_maxIntPlusOne
-- --     , bogus "too many positive digits" pos_tooManyDigits
-- --     ]



-- -- toInt_valid : Test
-- -- toInt_valid =
-- --   describe "toInt: valid strings"
-- --     [
--     -- , test "alternate positive format" <|
--     --     -- it doesn't print the same as the source, so special check
--     --   \_ ->
--     --     String.toInt "+123" |> Expect.equal (Ok 123)
-- --    ]


-- -- oddBoundaries : Test
-- -- oddBoundaries =
-- --   describe "boundary values are odd"
-- --     [ -- concat <|
--         -- -- It turns out Random.maxInt isn't the biggest int.
--         -- -- The following works, though it's bigger than maxint
--         -- let
--         --   explicitMaxInt =  2147483647        -- for visual comparison
--         --   input =          "2147483647999999"
--         --   expected =        2147483647999999
--         -- in
--         --   [ valid "big" input expected
--         --   , test "I have right value for maxint" <|
--         --       \_ -> 
--         --         Expect.equal explicitMaxInt maxInt
--           -- ]
        
--     {- This one is interesting: it produces the wrong answer!
    
--     , valid "wrong!" "21474836479999999999" 21474836479999999999
        
--         Ok 21474836480000000000
--         ╷
--         │ Expect.equal
--         ╵
--         Ok 3028092406290448400
        
--       Notice that the `toInt` result (the first number)
--       is the input value + 1. Which makes me think the value
--       was promoted to a float.
      
--       Note also that the expected value shown in the error
--       isn't what I typed in the test. Instead, it's a number
--       with fewer digits. Unchecked integer overflow?
          
--       To provide more evidence that big integers are converted to
--       floats, consider this:
  
--     , valid "float?" "21474836479999999999999" 21474836479999999999999
  
--         Ok 2.147483648e+22
--         ╷
--         │ Expect.equal
--         ╵
--         Ok 2826378202081919000
--     -}
--     -- ]

-- -- toInt_invalid : Test
-- -- toInt_invalid =
-- --   describe "toInt: invalid strings"
-- --     [
--     --   test "format of error message" <|
--     --     \_ ->
--     --       MUT.toInt "not a string"
--     --         |> Expect.equal (Err "could not convert string 'not a string' to an Int")
                 
--     -- , describe "what provokes error messages"
--     --     [ bogus "empty string" ""
--     --     , bogus "leading alpha" "a3"
--     --     , bogus "trailing alpha" "3a"
--     --     , bogus "distantly trailing alpha" "3       a"
          
--     --     , bogus "extra -" "--3"
--     --     , bogus "extra +" "++3"
  
  
--         {- Another interesting case: 
  
--         , bogus "lone -" "-"
  
--               Ok NaN
--               ╷
--               │ Expect.err
--               ╵
--               Err _
  
--           It produces a NaN (which is a Float value), wrapped in Ok!
--         -}       
  
--         -- , bogus "leading whitespace" " 3"
--         -- , bogus "trailing whitespace" "3 "
--         -- , bogus "float" "3." -- toFloat would accept this.
--     --     ]
--     -- ]


-- -- Private

-- expectSameString : String -> Result err ok -> Expectation
-- expectSameString input result =
--   case result of
--     Err _ ->
--       Expect.fail <| "result " ++ toString result ++ "is an Err."

--     Ok val ->
--       toString val |> Expect.equal input

-- ok : value -> (Result err value -> Expectation)
-- ok expected = Expect.equal (Ok expected)

-- expectNothing : Maybe a -> Expectation
-- expectNothing = Expect.equal Nothing

        

-- valid : String -> String -> Int -> Test
-- valid comment input expected =
--   test comment <|
--     \_ -> 
--       MUT.toInt input
--         |> Expect.all
--            [ ok expected
--            , expectSameString input
--            ]

-- validValue : String -> String -> Int -> Test
-- validValue comment input expected =
--   test comment <|
--     \_ -> 
--       MUT.toInt input
--         |> ok expected

-- bogus : String -> String -> Test
-- bogus comment input =
--   test comment <|
--     \_ -> 
--       MUT.toInt input |> Expect.err



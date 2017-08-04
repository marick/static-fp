module IVBits.StringTest exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result

{- I'm imagining this file as being a complete set of tests for 
   `String.elm`. So it'd have tests for `toInt`, `reverse`, `trim`, and
   so forth. 

   That's a logical structure like this:

     about the String module
       about `toInt`
         about valid integer strings
         about invalid integer strings
       about `reverse`
       about `trim`

   The elm-test documentation encourages you to have the physical structure
   mimic the logical structure:

   suite : Test
   suite =
     describe "String"
       [ describe "toInt"
           [...
           ]
       , describe "reverse"
           [...
           ]
       , describe "trim"
           [...
           ]
       ]
        
   I choose to have more top level test suites, essentially flattening one or
   two levels of the hierarchy, 

      toInt_valid : Test
      toInt_invalid : Test
      reverse : Test
      trim : Test

   Why? I use Emacs. It can, via `set-selective-display`, be told not
   to show anything deeper than a certain level of indentation. In
   theory, that makes it easy to get an easily-scrollable high-level view
   of the test suite. 

   In practice, I find that awkward. Either things I want to see are too
   deeply nested, or - if I show more deeply nested things - there's a lot
   of noise I'm not interested in. 

   Also, not everyone uses Emacs. (I know! Crazy, huh?)

   So I prefer using the syntax colorizer to create scannability. My
   setup shows declaration like `toInt_valid : Test` as green
   words. Scrolling and reading the left-justified green words seems
   quite efficient, and it lets me group tests more flexibly.

   In what follows, choose the style you like best and delete the other one.
-}


suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ describe "valid strings"
            [ test "simple example" <|
                \_ ->
                  String.toInt "123" |> Expect.equal (Ok 123)
            ]

        , describe "invalid strings"
            [ test "format of error message" <|
                \_ ->
                  String.toInt "not a string"
                    |> Expect.equal (Err "could not convert string 'not a string' to an Int")
            
            , test "reject leading alpha characters" <| 
                \_ ->
                  (String.toInt "a3" |> Expect.err)
            ]
        ]
    ]
          

toInt : Test
toInt =
  describe "toInt" -- this level is redundant, but it makes error messages clearer.
    [ describe "valid strings"
        [ test "simple example" <|
            \_ ->
              String.toInt "123" |> Expect.equal (Ok 123)
        ]

    , describe "invalid strings"
        [ test "format of error message" <|
            \_ ->
              String.toInt ""
                |> Expect.equal (Err "could not convert string '' to an Int")
            
        , test "reject leading alpha characters" <| 
            \_ ->
              (String.toInt "a3" |> Expect.err)
        ]
    ]

    

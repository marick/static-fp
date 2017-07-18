module IVBits.StringTestStart exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result

toInt : Test
toInt =
  describe "toInt"
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

module IVBits.StringTest exposing (..)

import Test exposing (..)
import Expect 
import TestUtil exposing (..)
import Result.Extra exposing (isErr)

suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ test "valid" <| \_ -> 
            String.toInt "123" => Ok 123
        , test "invalid" <| \_ ->
            String.toInt "a" ==> isErr
        ]
    ]


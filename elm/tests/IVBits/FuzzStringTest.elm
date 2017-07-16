module IVBits.FuzzStringTest exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result

import Fuzz

suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ fuzz Fuzz.int "valid" <|
            \i ->
              Expect.equal (toString i |> String.toInt) (Ok i)
        ]
    ]

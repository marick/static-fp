module IVBits.StandardStringTest exposing (..)

import Test exposing (..)
import Expect
import Result.Extra as Result

suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ test "valid" <|
            \_ -> 
              Expect.equal (String.toInt "123") (Ok 123)
        , test "invalid" <|
            \_ -> 
              Expect.true "err"
                (String.toInt "a" |> Result.isErr)
        ]
    ]

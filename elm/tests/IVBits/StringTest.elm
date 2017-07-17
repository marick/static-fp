module IVBits.StringTest exposing (..)

import Test exposing (..)
import Expect 
import TestUtil exposing (..)
import Result.Extra exposing (isErr)

suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ check "valid" (String.toInt "123") => Ok 123
        , check "invalid" (String.toInt "a") ==> isErr
        ]
    ]


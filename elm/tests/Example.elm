module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)


suite : Test
suite =
  test "foo" <|
    \_ ->
      Expect.equal 1 1

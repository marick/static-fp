module TestUtil exposing ((=>))

import Expect exposing (Expectation)

{-| Allows a style of tests patterned off book examples and repls, with
    the expected result on the right.

    test "success case" <| \_ ->
      1 + 1 => 2
-}
(=>) : a -> a -> Expectation
(=>) actual expected =
  Expect.equal actual expected
infixl 0 =>


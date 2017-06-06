module IvArchitecture.Common.FloatStringTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import IvArchitecture.Common.FloatString as FloatString exposing (FloatString)

defaultFloat = 123456789.0  -- Don't reuse this!
defaultFloatString = FloatString.fromFloat defaultFloat

suite : Test
suite =
  describe "fromString"
    [ test "empty string" <|
        expectFloatString "" FloatString.isEmpty
    , test "blank string" <|
        expectFloatString "   " FloatString.isEmpty

    , test "canonical float" <|
        expectFloatString "3.6" FloatString.isValid
    , test "no decimal point" <|
        expectFloatString "1" FloatString.isValid
    , test "nothing following decimal point" <|
        expectFloatString "3." FloatString.isValid

    , test "spacing before" <|
        expectFloatString "\n   3.6" FloatString.isValid
    , test "spacing after" <|
        expectFloatString "3.6   \t" FloatString.isValid

    , test "pure invalid" <| expectDefault "a"
    , test "invalid character at end" <| expectDefault "3.1a"
    , test "invalid character after space end" <| expectDefault "3.1 a"
    , test "invalid character with simple float" <| expectDefault "3a"
    ]

expectFloatString : String -> (FloatString -> Bool) -> (() -> Expectation)
expectFloatString input predicate = 
  \_ ->
    Expect.all
      [ Expect.equal input << FloatString.asString
      , Expect.equal True << predicate
      ]
     (FloatString.fromString defaultFloatString input)

expectDefault : String -> (() -> Expectation)
expectDefault input =
  \_ ->
    Expect.all
      [ Expect.equal (FloatString.asString defaultFloatString)
          << FloatString.asString
      , Expect.equal True << FloatString.isValid
      ]
     (FloatString.fromString defaultFloatString input)
       

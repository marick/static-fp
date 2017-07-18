module IVBits.TestExamples exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Result.Extra as Result

suite : Test
suite =
  describe "arithmetic"
    [ test "+" <|
        \_ ->
          1 + 1 |> Expect.equal 2
    , test "-" <|
        \_ ->
          1 - 1 |> Expect.equal 0
    ]


errTest : Test
errTest =
  test "an empty string is rejected" <|
    \_ ->
      String.toInt ""
        |> Result.isErr
        |> Expect.true ""
    
isErr : Result a b -> Expectation
isErr result =
  case result of
    Ok _ ->
      Expect.fail ("Actual: " ++ toString result)
    Err _ ->
      Expect.pass


anotherErrTest : Test
anotherErrTest =
  test "another empty string is rejected" <|
    \_ ->
      String.toInt "" |> isErr


doubleCheck : Test
doubleCheck =
  test "parents are included" <|
    \_ ->
      let
        calculated = [ "Dawn"
                     , "Brian"
                     , "Paul"
                     , "Sophie"
                     ]
      in
        calculated
          |> Expect.all
             [ List.member "Dawn" >> Expect.true "has Dawn"
             , List.member "Brian" >> Expect.true "has Brian"
             ]
               

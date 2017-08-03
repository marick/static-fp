module IVBits.ValidatorsTest exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.Validators as Validated

import Test exposing (..)
import Expect


validHours : Test
validHours =
  describe "valid hours"
    [
      test "elm-test objects to empty tests" <|
        \_ -> Expect.equal 1 1
    ]

invalidHours : Test
invalidHours =
  describe "invalid hours"
    [
      test "elm-test also objects to duplicate test comments" <|
        \_ -> Expect.equal 1 1
    ]

validMinutes : Test
validMinutes =
  describe "valid minutes"
    [
      test "temporary" <|
        \_ -> Expect.equal 1 1
    ]

invalidMinutes : Test
invalidMinutes =
  describe "invalid minutes"
    [
      test "also temporary" <|
        \_ -> Expect.equal 1 1
    ]


module IVBits.ValidatorsTestSolution exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.ValidatorsSolution as Validated exposing (ValidatedString)

import Test exposing (..)
import Expect

type alias Comment = String
type alias Input = String


tryValid : (String -> ValidatedString a) -> Comment -> Input -> a
         -> Test
tryValid validator comment input expected =
  test comment <|
    \_ ->
      Expect.all
        [ .literal >> Expect.equal input
        , .value >> Expect.equal (Just expected)
        ]
        (validator input)


tryInvalid : (String -> ValidatedString a) -> Comment -> Input
           -> Test
tryInvalid validator comment input =
  test comment <|
    \_ ->
      Expect.all
        [ .literal >> Expect.equal input
        , .value >> Expect.equal Nothing
        ]
        (validator input)


validHours : Test
validHours =
  describe "valid hours"
    (let
      try = tryValid Validated.hours
     in
       [ try "positive number" "12" 12
       , try "zero is valid (but the form should require the minutes to be non-zero)"
             "0" 0
       , try "a number within whitespace" " 34 " 34
       ])

invalidHours : Test
invalidHours =
  describe "invalid hours"
    (let
      try = tryInvalid Validated.hours
     in
       [ try "some random bogus value" "a"
       , try "specially bogus: a negative number" "-1"
       , try "interior spaces are still disallowed" "1 2"
       ])

validMinutes : Test
validMinutes =
  describe "valid minutes"
    (let
      try = tryValid Validated.minutes
     in
       -- duplicating these to make book explanation easier
       [ try "positive number" "12" 12
       , try "zero is valid (but the form should require the hours to be non-zero)"
             "0" 0
       , try "a number within whitespace" " 34 " 34
       -- this is new
       , try "largest partial hour works" " 59 " 59
       ])

invalidMinutes : Test
invalidMinutes =
  describe "invalid minutes"
    (let
      try = tryInvalid Validated.minutes
     in
       -- as above, these are duplicates
       [ try "some random bogus value" "a"
       , try "specially bogus: a negative number" "-1"
       , try "interior spaces are still disallowed" "1 2"

       -- this is new
       , try "has to be a partial hour" "60"
       ])


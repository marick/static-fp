module IVFlat.Form.TypesTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing (..)
import IVFlat.Form.Types as Form exposing (JustFields, FinishedForm)
import IVFlat.Form.Validators as Validated
import IVFlat.Generic.Measures as M

fields : String -> String -> String -> JustFields {}
fields dripRate hours minutes =
  { desiredDripRate = Validated.dripRate dripRate
  , desiredHours = Validated.hours hours
  , desiredMinutes = Validated.minutes minutes
  }

finished : Float -> Int -> Int -> FinishedForm
finished dripRate hours minutes = 
  { dripRate = M.dripRate dripRate
  , hours = M.hours hours
  , minutes = M.minutes minutes
  }

runner : (JustFields {} -> a) -> String -> String -> String -> a
runner functionUnderTest rate hours minutes =
  fields rate hours minutes |> functionUnderTest


suite : Test
suite =
  describe "Forms"
    [ describe "AllValues is all or Nothing"
        (let
          run = runner Form.allValues
        in
          [ check "every field has a valid value"
              (run "1" "2" "3")    => Just (finished 1 2 3)
          , check "it's OK for hours to be 0"
              (run "1.5" "0" "3")  => Just (finished 1.5 0 3)
          , check "it's OK for minutes to be 0"
              (run "1" "2" "0")    => Just (finished 1 2 0)
              
          , check "bad drip rate"
              (run "OOPS" "2" "3") => Nothing
          , check "bad hours"
              (run "1" "OOPS" "3") => Nothing
          , check "bad minutes"
              (run "1" "2" "OOPS") => Nothing
          , check "both hours and minutes are zero"
              (run "1" "0" "0")    => Nothing
          ])

    -- This is where Midje-style mocks shine.
    , describe "isFormIncomplete"
        (let
           run = runner Form.isFormIncomplete
        in
          [ -- no need to sample all the negative values
            check "bad drip rate, for example"
              (run "OOPS" "2" "3") => True
            -- be a little pickier for the valid values
          , check "every field has a valid value"
              (run "1" "2" "3")    => False
          , check "it's OK for hours to be 0"
              (run "1.5" "0" "3")  => False
          , check "it's OK for minutes to be 0"
              (run "1" "2" "0")    => False
          ])
    ]

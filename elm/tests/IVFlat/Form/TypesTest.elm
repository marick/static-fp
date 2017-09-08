module IVFlat.Form.TypesTest exposing (..)

import Test exposing (..)
import TestBuilders as Build
import IVFlat.Form.Types as Form exposing (JustFields, FinishedForm)
import IVFlat.Form.Validators as Validated
import IVFlat.Generic.Measures as M

fields : String -> String -> String -> JustFields {}
fields dripRate hours minutes =
  { desiredDripRate = Validated.dripRate dripRate
  , desiredHours = Validated.hours hours
  , desiredMinutes = Validated.minutes minutes
  }

just : Float -> Int -> Int -> Maybe FinishedForm
just dripRate hours minutes = 
  Just { dripRate = M.dripRate dripRate
       , hours = M.hours hours
       , minutes = M.minutes minutes
       }

runner : (JustFields {} -> a) -> String -> String -> String -> a
runner functionUnderTest rate hours minutes =
  fields rate hours minutes |> functionUnderTest

    
allValues : Test
allValues =
  let
    run = runner Form.allValues
    when = Build.f_3_expected_comment run
    bogus = Build.f_expected_3_comment run Nothing
  in
    describe "allValues is all or nothing"
      [ when ("1",   "2", "3") (just 1 2 3)   "every field is valid"
      , when ("1.5", "0", "3") (just 1.5 0 3) "hours can be 0 if minutes are not"
      , when ("1",   "2", "0") (just 1 2 0)   "minutes can also be 0"
        
      , bogus ("OOPS", "2", "3")    "bad drip rate"
      , bogus ("1", "OOPS", "3")    "bad hours"
      , bogus ("1", "2", "OOPS")    "bad minutes"
        
      , bogus ("1", "0", "0")       "both hours and minutes are zero"
      ]

isFormIncomplete : Test
isFormIncomplete = 
  let
    run = runner Form.isFormIncomplete
    incomplete = Build.f_expected_3_comment run True
    complete = Build.f_expected_3_comment run False
  in
    describe "isFormIncomplete"
      [ -- no need to sample all the reasons the form is incomplete
        incomplete ("OOPS", "2", "3")   "bad drip rate, for example"

      , complete ("1", "2", "3")        "every field has a valid value"
      , complete ("1.5", "0", "3")      "it's OK for hours to be 0"
      , complete ("1", "2", "0")        "it's OK for minutes to be 0"
      ]

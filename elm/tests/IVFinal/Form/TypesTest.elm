module IVFinal.Form.TypesTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing ((=>))
import IVFinal.Form.Types as Form exposing (JustFields, FinishedForm)
import IVFinal.Form.InputFields as Field
import IVFinal.Generic.Measures as M

fields : String -> String -> String -> JustFields {}    
fields dripRate hours minutes =
  { desiredDripRate = Field.dripRate dripRate
  , desiredHours = Field.hours hours
  , desiredMinutes = Field.minutes minutes
  }

finished : Float -> Int -> Int -> FinishedForm
finished dripRate hours minutes = 
  { dripRate = M.dripRate dripRate
  , hours = M.hours hours
  , minutes = M.minutes minutes
  }
  

suite : Test
suite =
  describe "Forms"
    [ describe "AllValues is all or Nothing"
        [ test "success case" <| \_ ->
            Form.allValues (fields "1" "2" "3")
            => Just (finished 1 2 3)
        , test "bad drip rate" <| \_ ->
            Form.allValues (fields "OOPS" "2" "3")
            => Nothing
        , test "bad hours" <| \_ ->
            Form.allValues (fields "1" "OOPS" "3")
            => Nothing
        , test "bad minutes" <| \_ ->
            Form.allValues (fields "1" "2" "OOPS")
            => Nothing
        , test "both hours and minutes are zero" <| \_ ->
            Form.allValues (fields "1" "0" "0")
            => Nothing
        ]

    -- This is where Midje-style mocks shine.
    , describe "isFormIncomplete"
      [ describe "bad values"
          [ test "bad drip rate" <| \_ ->
              Form.isFormIncomplete (fields "OOPS" "2" "3")
              => True
          , test "bad hours" <| \_ ->
              Form.isFormIncomplete (fields "1" "OOPS" "3")
              => True
          , test "bad minutes" <| \_ ->
              Form.isFormIncomplete (fields "1" "2" "OOPS")
              => True
          , test "both hours and minutes are zero" <| \_ ->
              Form.isFormIncomplete (fields "1" "0" "0")
              => True
          ]
      , describe "valid values"
        [ test "just hours" <| \_ ->
            Form.isFormIncomplete (fields "1" "1" "0")
            => False
        , test "just minutes" <| \_ ->
            Form.isFormIncomplete (fields "1" "0" "1")
            => False
        ]
      ]
    ]

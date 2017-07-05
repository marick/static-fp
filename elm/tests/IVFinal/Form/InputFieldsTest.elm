module IVFinal.Form.InputFieldsTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing (..)
import IVFinal.Types exposing (FinishedForm)
import IVFinal.Form.InputFields as Field
import IVFinal.Generic.Measures as M
import Random

commonFailures f =
  [ test "empty string" <| \_ ->
      (f "").value => Nothing
  , test "blank" <| \_ ->
      (f "     ").value => Nothing
  , test "alpha" <| \_ ->
      (f "a").value => Nothing
  , test "bare negative" <| \_ ->
      (f "-").value => Nothing
  , test "negative" <| \_ ->
      (f "-3").value => Nothing
  , test "bare positive" <| \_ ->
      (f "+").value => Nothing
  , test "trailing alpha" <| \_ ->
      (f "3    a").value => Nothing
  ]

commonSuccesses inF outF =
  [ test "plain integer" <| \_ ->
      (inF "3").value => Just (outF 3)
  , test "spaces" <| \_ ->
      (inF "    55    ").value => Just (outF 55)
  ]
  
  

suite : Test
suite =
  describe "InputFields"
    [ describe "dripRate common failures"
        (commonFailures Field.dripRate)
    , describe "dripRate common successes"
        (commonSuccesses Field.dripRate M.dripRate)
    , describe "dripRate special cases"
        [ test "it can handle floats" <| \_ ->
            (Field.dripRate " 3.5").value => Just (M.dripRate 3.5)
        , test "floats require nothing after the decimal point" <| \_ ->
            (Field.dripRate " 3.").value => Just (M.dripRate 3)
        , test "negative floats are not allowed" <| \_ ->
            (Field.dripRate "-3.3").value => Nothing
        , test "zero is not allowed" <| \_ ->
            (Field.dripRate "0").value => Nothing
        , test "but even a very small number is" <| \_ ->
            (Field.dripRate "0.001").value => Just (M.dripRate 0.001)
        , test "a ridiculously large number (infinity) fails" <| \_ ->
            (Field.dripRate "33339339393939393939393939393939383838383838383838383838383838383333933939393939393939393939393938383838383838383838383838383838333393393939393939393939393939393838383838383838383838383838383833339339393939393939393939393939383838383838383838383838383838383333933939393939393939393939393938383838383838383838383838383838").value => Nothing
        ]

    , describe "hours common failures"
        (commonFailures Field.hours)
    , describe "hours common successes"
        (commonSuccesses Field.hours M.hours)
    , describe "hours special cases"
        [ test "it rejects floats" <| \_ ->
            (Field.hours "3.0").value => Nothing
        , test "it accepts 0" <| \_ ->
            (Field.hours " 0").value => Just (M.hours 0)
        , test "it accepts big numbers" <| \_ ->
            (Field.hours <| toString Random.maxInt).value
              => Just (M.hours Random.maxInt)
        , test "but not ridiculously large ones" <| \_ ->
            (Field.hours "2147483648").value => Nothing
        ]

    , describe "minutes common successes"
        (commonSuccesses Field.minutes M.minutes)
    , describe "minutes common failures"
        (commonFailures Field.minutes)
    , describe "minutes special cases"
        [ test "it rejects floats" <| \_ ->
            (Field.minutes "3.0").value => Nothing
        , test "it accepts 0" <| \_ ->
            (Field.minutes " 0").value => Just (M.minutes 0)
        , test "it accepts 59" <| \_ ->
            (Field.minutes "59    ").value => Just (M.minutes 59)
        , test "but not 60 - that's a whole hour" <| \_ ->
            (Field.minutes "60").value => Nothing
        ]
    ]

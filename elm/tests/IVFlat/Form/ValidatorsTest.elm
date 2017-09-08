module IVFlat.Form.ValidatorsTest exposing (..)

import IVFlat.Generic.ValidatedString exposing (ValidatedString)
import IVFlat.Form.Validators as Validated
import IVFlat.Generic.Measures as M

import Test exposing (..)
import TestBuilders as Build


validatorsRetainStrings : Test
validatorsRetainStrings =
  let
    minutes = Build.f_1_expected_comment (Validated.minutes >> .literal)
    hours = Build.f_1_expected (Validated.hours >> .literal)
    dripRate = Build.f_1_expected (Validated.dripRate >> .literal)
  in
    describe "validators retain strings"
      [ -- Overkill to test all three cases
        minutes "3"     "3"           "success case"
      , minutes "!!!"   "!!!"         "error case"

      , hours "333" "333"
      , hours "ab" "ab"
      , dripRate "3" "3"
      , dripRate "wrong" "wrong"
      ]

hours : Test
hours =
  let
    run = (Validated.hours >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
    expect n = Just (M.hours n)
  in
    describe "hours"
      [ rejects "1a"           "the usual non-numeric values are rejected"
      , rejects "1.0"          "rejects floats"

      , when "24" (expect 24)  "upper boundary"
      , rejects "25"           "too big"
        
      , when "0" (expect 0)    "0 is allowed"
      , rejects "-1"           "negative numbers are disallowed"

      , when " 3 " (expect 3)  "spaces are allowed"
      ]      


minutes : Test
minutes =
  let
    run = (Validated.minutes >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
    expect n = Just (M.minutes n)
  in
    describe "minutes"
      [ rejects "+"              "the usual non-numeric values are rejected"
      , rejects "5.3"            "rejects floats"

      , when "59" (expect 59)    "upper boundary"
      , rejects "60"             "too big"
        
      , when "0" (expect 0)      "0 is allowed"
      , rejects "-1"             "negative numbers are disallowed"

      , when " 35 " (expect 35)  "spaces are allowed"
      ]      


dripRate : Test
dripRate =
  let
    run = (Validated.dripRate >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
    expect n = Just (M.dripRate n)
  in
    describe "drip rate"
      [ rejects "88888888888888888888888888888888888888888888888888888888888"
                                          "pathological values are rejected"

      , when "100.0" (expect 100.0)       "upper boundary"
      , rejects "100.1"                   "this is a silly drip rate"
        
      , rejects "0"                       "dripping has to happen"
      , when "0.000001" (expect 0.000001) "it can be really slow, though"
      , rejects "-0.1"                    "but not negatively slow"

      , when "3" (expect 3.0)             "decimal point is not required"
      , when "3." (expect 3.0)            "there does not need to be anytbhing after point"

      , when " 3.5 " (expect 3.5)         "spaces are allowed"
      ]      

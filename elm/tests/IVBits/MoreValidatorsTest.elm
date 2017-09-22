module IVBits.MoreValidatorsTest exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.MoreValidators as Validated
import Test exposing (..)

-- This allows me to construct tabular tests.
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

{- Note: these tests deliberately avoid tickling the bug
   in `toInt`'s handling of "+" and "-" alone. They also
   don't even cover the use of '+' at all.
-}


      
hours : Test
hours =
  let
    run = (Validated.hours >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
  in
    describe "hours"
      [ rejects "1a"           "the usual non-numeric values are rejected"
      , rejects "1.0"          "rejects floats"

      , when "0" (Just 0)      "0 is allowed"
      , rejects "-1"           "negative numbers are disallowed"

      , when " 3 " (Just 3)    "spaces are allowed"

      , when "24" (Just 24)    "a 24 hour drip is barely conceivable"
      , rejects "25"           "but anything larger is ridiculous"
      ]      


minutes : Test
minutes =
  let
    run = (Validated.minutes >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
  in
    describe "minutes"
      [ rejects "a+"             "the usual non-numeric values are rejected"
      , rejects "5.3"            "rejects floats"

      , when "59" (Just 59)      "upper boundary"
      , rejects "60"             "too big"
        
      , when "0" (Just 0)        "0 is allowed"
      , rejects "-1"             "negative numbers are disallowed"

      , when " 35 " (Just 35)    "spaces are allowed"
      ]      


dripRate : Test
dripRate =
  let
    run = (Validated.dripRate >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
  in
    describe "drip rate"
      [ when "100.0" (Just 100.0)         "upper boundary"
      , rejects "100.1"                   "this is a silly drip rate"
        
      , rejects "0"                       "dripping has to happen"
      , when "0.000001" (Just 0.000001)   "it can be really slow, though"
      , rejects "-0.1"                    "but not negatively slow"

      , when "3" (Just 3.0)               "decimal point is not required"
      , when "3." (Just 3.0)              "there does not need to be anytbhing after point"

      , when " 3.5 " (Just 3.5)           "spaces are allowed"
      ]      

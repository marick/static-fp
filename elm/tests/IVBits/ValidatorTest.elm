module IVBits.ValidatorTest exposing (..)

-- I'm using `Validated` because it reads nicely: `Validated.hours`
import IVBits.Validator as Validated

import Test exposing (..)

-- This allows me to construct tabular tests.
import TestBuilders as Build

validatorsRetainStrings : Test
validatorsRetainStrings =
  let
    minutes = Build.f_1_expected_comment (Validated.minutes >> .literal)
  in
    describe "validators retain strings"
      [ minutes "3"     "3"           "success case"
      , minutes "!!!"   "!!!"         "error case"
      ]

minutes : Test
minutes =
  let
    run = (Validated.minutes >> .value)
    when = Build.f_1_expected_comment run
    rejects = Build.f_expected_1_comment run Nothing
  in
    describe "minutes"
      [ when "59" (Just 59)      "upper boundary"
      , rejects "60"             "too big"
        
      , when "0" (Just 0)        "0 is allowed"
      , rejects "-1"             "negative numbers are disallowed"
      ]

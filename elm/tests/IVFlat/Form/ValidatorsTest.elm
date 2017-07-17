module IVFlat.Form.ValidatorsTest exposing (..)

import IVFlat.Generic.ValidatedString exposing (ValidatedString)
import IVFlat.Form.Validators as Validated
import IVFlat.Generic.Measures as M

import Test exposing (..)
import TestUtil exposing (..)
import Random exposing (maxInt)
import Maybe.Extra as Maybe



{-| Generalizing over the different validators
  value "string"            -- run the validator and return the `value` part
  literal "input"           -- ditto, but return the `literal` part
  rejects "comment" "input" -- run validator and insist it return nothing
  accepts "comment" "input" -- ditto, but insist it return any `Just`
  measured number           -- construct an appropriate (Just (wrapper number))
-}

helpers validator wrapper =
  let
    value input =
      (validator input).value
    literal input =
      (validator input).literal
    rejects comment input =
      check comment (value input) => Nothing
    accepts comment input =
      check comment (value input) ==> Maybe.isJust
    measured value =
      Just (wrapper value)
  in
    { value = value
    , literal = literal
    , accepts = accepts
    , rejects = rejects
    , measured = measured
    }



validatorsAlwaysRetainStrings {rejects, accepts} =
  let
    badString = "xyzzy"
    goodString = "3"
  in
    describe "original input is always retained"
      [ rejects "see this failure?" badString
      , check "bad string retained" badString => badString
        
      , accepts "see this success?" goodString
      , check "goods string retained" goodString => goodString
      ]

      
someStringsCanNeverBeAnyKindOfValidNumber {rejects, literal} =
  describe "strings invalid to all validators" 
    [ rejects "empty string"      ""
    , rejects "blank"             "      "  
    , rejects "alphabetical"      "a"     
    , rejects "trailing alpha"    "3    a" 
    , rejects "minus sign"        "-"          
    , rejects "plus sign"         "+"           
    -- Neither drip rate, hours, nor minutes can be negative
    , rejects "negative number"   "-3"    
    ]

someStringsWorkForAllValidators {value, literal, measured} =
  describe "strings valid to all validators" 
    [ check "plain integer" (value "3")    => measured 3
    , check "spaces"        (value " 55 ") => measured 55
    ]

dripRate : Test
dripRate =
  let
    ({value, measured, rejects} as specialization) =
      helpers Validated.dripRate M.dripRate
  in
    describe "dripRate"
      [ validatorsAlwaysRetainStrings specialization
      , someStringsCanNeverBeAnyKindOfValidNumber specialization
      , someStringsWorkForAllValidators specialization
         
      , describe "special cases for floating point"
          [ check "valid float"       (value "3.5")    => measured 3.5
          , check "float with spaces" (value " 3.5 ")  => measured 3.5
          , check "floats allow emptiness after the decimal point"
                                      (value " 3.")     => measured 3.0

          , rejects "zero" "0"
          , rejects "negative floats" "-0.3"
          , check "even a very small number is accepted"
                                      (value "0.001") => measured 0.001
          , rejects "a ridiculously large number (infinity)"
              "33339339393939393939393939393939383838383838383838383838383838383333933939393939393939393939393938383838383838383838383838383838333393393939393939393939393939393838383838383838383838383838383833339339393939393939393939393939383838383838383838383838383838383333933939393939393939393939393938383838383838383838383838383838"
          ]
       ]

hours : Test
hours =
  let
    ({value, measured, rejects} as specialization) =
      helpers Validated.hours M.hours
  in
    describe "hours"
      [ validatorsAlwaysRetainStrings specialization
      , someStringsCanNeverBeAnyKindOfValidNumber specialization
      , someStringsWorkForAllValidators specialization
      
      , describe "special cases"
        [ rejects "floats" "3.0"
        , check "zero is accepted" (value "0") => measured 0
        , check "big numbers" (value <| toString maxInt) => measured maxInt
        , rejects "ridiculously large ones" "2147483648"
        ]
      ]

minutes : Test
minutes =
  let
    ({value, measured, rejects} as specialization) =
      helpers Validated.minutes M.minutes
  in
    describe "minutes"
      [ validatorsAlwaysRetainStrings specialization
      , someStringsCanNeverBeAnyKindOfValidNumber specialization
      , someStringsWorkForAllValidators specialization
      
      , describe "special cases"
        [ rejects "floats" "3.0"
        , check "zero is ok" (value "0") => measured 0
        , check "59 is ok" (value "59") => measured 59
        , rejects "60 - it's a whole hour" "60"
        ]
      ]

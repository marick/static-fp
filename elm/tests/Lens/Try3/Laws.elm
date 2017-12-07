module Lens.Try3.Laws exposing (..)

import Tagged exposing (Tagged(..))
import Test exposing (..)
import TestBuilders exposing (..)

{-         Laws for the CLASSIC and UPSERT Lens.          -}

set_part_can_be_gotten (Tagged {get, set}) whole {new} =
  equal (get (set new whole)) new
    "set part can be gotten"

setting_part_with_same_value_leaves_whole_unchanged (Tagged {get, set}) whole = 
  equal (set (get whole) whole) whole
    "setting part with the same value leaves the whole unchanged"

set_changes_only_the_given_part (Tagged {set}) whole {overwritten, new} = 
  let
    inOneStep  = whole |>                    set new
    inTwoSteps = whole |> set overwritten |> set new
  in
    equal inTwoSteps   inOneStep
      "set changes only the given part (no counter, etc.)"

classic lens whole inputValues comment = 
  describe comment
    [ set_part_can_be_gotten
        lens whole inputValues

    , setting_part_with_same_value_leaves_whole_unchanged
        lens whole 

    , set_changes_only_the_given_part
        lens whole inputValues
    ]


{-         Laws for the HUMBLE Lens.          -}

-- Even where the laws have the same meaning as for the classic lens, the type
-- signatures are too different to reuse them.

-- Like `set_part_can_be_gotten`.  Difference is that the law applies only 
-- when the whole already contains the part.
humble_set_part_can_be_gotten
  (Tagged {get, set}) whole {original, new}  =
  describe "when a part is present, `set` overwrites it"
    [ 
      equal  (get          whole)    (Just original)  "appropriate `whole`"
    , equal_ (get (set new whole))   (Just new)
    ]

-- Like `setting_part_with_same_value_leaves_whole_unchanged`. Difference
-- is that the law applies only when the whole already contains the
-- part.
humble_setting_part_with_same_value_leaves_whole_unchanged
  (Tagged {get, set}) whole {original} =
  describe "retrieving a part, then setting it back"
    [ equal  (get          whole)     (Just original)  "`whole` contains original"
    , equal_ (set original whole)     whole
    ]

humble_does_not_create
  (Tagged {get, set}) whole {new} = 
  describe "when a part is missing, `set` does nothing"
    [ equal (get          whole)      Nothing     "see: part is missing"
    , equal (get (set new whole))     Nothing     "`get` still gets nothing"
    , equal      (set new whole)      whole       "nothing else changed"
    ]

-- Laws are separated into present/missing cases because some types
-- will have more than one way for a part to be missing
    
humblePartPresent lens whole ({original, new} as inputValues) = 
  describe "part present"
    [ humble_set_part_can_be_gotten
        lens whole inputValues

    , humble_setting_part_with_same_value_leaves_whole_unchanged
        lens whole inputValues

    , set_changes_only_the_given_part  -- Note we can reuse lens law
        lens whole inputValues

    -- check for test-writer mistakes
    , notEqual original new           "equal values would be a weak test case"  
    ]

humblePartMissing lens whole inputValues why = 
  describe ("part not present: " ++ why)
    [ humble_does_not_create 
        lens whole inputValues
    ]

---- OneCase laws

{-         Laws for the OneCase Lens.          -}

one_case_gotten_part_can_be_set_back (Tagged {get, set}) whole part  =
  describe "if `get` succeeds, `set` recreates the sum type value"
    [ equal  (get whole)    (Just part)   "get succeeds"
    , equal  (set part)     whole         "law is upheld"
    ]
    

one_case_set_part_can_be_gotten_back (Tagged {get, set}) whole part =
  describe "`get` always retrieves what `set` sets"
    [ equal       (set part)     whole          "whole and part match"
    , equal  (get (set part))    (Just part)    "law is upheld"
    ]
    
oneCase lens constructor comment =
  let
    arbitrary = (1, 2)
  in
    describe comment
      [ one_case_gotten_part_can_be_set_back lens (constructor arbitrary) arbitrary
      , one_case_set_part_can_be_gotten_back lens (constructor arbitrary) arbitrary
      ]

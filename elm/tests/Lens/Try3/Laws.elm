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
    a_direct_change =        whole |>                    set new
    change_that_overwrites = whole |> set overwritten |> set new
  in
    equal change_that_overwrites   a_direct_change
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
humblelens_set_part_can_be_gotten
  (Tagged {get, set}) whole {original, new}  =
  describe "when an part is present, set overwrites it"
    [ notEqual original new                           "test values allow difference to be seen"  
    , equal  (get          whole)    (Just original)  "`whole` contains original"
    , equal_ (get (set new whole))   (Just new)
    ]

-- Like `setting_part_with_same_value_leaves_whole_unchanged`. Difference
-- is that the law applies only when the whole already contains the
-- part.
humblelens_setting_part_with_same_value_leaves_whole_unchanged
  (Tagged {get, set}) whole {original} =
  describe "retrieving an part, then setting it back"
    [ equal  (get          whole)     (Just original)  "`whole` contains original"
    , equal_ (set original whole)     whole
    ]

humblelens_does_not_create
  (Tagged {get, set}) whole {new} = 
  describe "when an part is missing, `set` does nothing"
    [ equal (get          whole)      Nothing     "show part is missing"
    , equal (get (set new whole))     Nothing     "`get` still gets nothing"
    , equal      (set new whole)      whole       "nothing else changed"
    ]

-- Laws are separated into present/missing cases because some types
-- will have more than one for an part to be missing
    
humblePartPresent lens whole inputValues = 
  describe "part present"
    [ humblelens_set_part_can_be_gotten
        lens whole inputValues

    , humblelens_setting_part_with_same_value_leaves_whole_unchanged
        lens whole inputValues

    , set_changes_only_the_given_part  -- Note we can reuse lens law
        lens whole inputValues
    ]

humblePartMissing lens whole inputValues why = 
  describe ("part not present: " ++ why)
    [ humblelens_does_not_create 
        lens whole inputValues
    ]

---- OnePart laws

{-         Laws for the HUMBLE Lens.          -}

gotten_part_can_be_set_back (Tagged {get, set}) whole part  =
  describe "if `get` succeeds, `set` recreates the sum type value"
    [ equal_ (get whole)    (Just part) 
    , equal_ (set part)     whole
    ]

set_part_can_be_gotten_back (Tagged {get, set}) whole part =
  describe "`get` always retrieves what `set` sets"
    [ equal_      (set part)     whole
    , equal_ (get (set part))    (Just part)
    ]
    
onePart lens constructor comment =
  let
    arbitrary = (1, 2)
  in
    describe comment
      [ gotten_part_can_be_set_back lens (constructor arbitrary) arbitrary
      , set_part_can_be_gotten_back lens (constructor arbitrary) arbitrary
      ]

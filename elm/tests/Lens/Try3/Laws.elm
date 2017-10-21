module Lens.Try3.Laws exposing (..)

import Tagged exposing (Tagged(..))
import Test exposing (..)
import TestBuilders exposing (..)

{-         Laws for the CLASSIC Lens.          -}

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


{-         Laws for the IFFY Lens.          -}

-- Even where the laws have the same meaning as for the classic lens, the type
-- signatures are too different to reuse them.

-- Like `set_part_can_be_gotten`.  Difference is that the law applies only 
-- when the whole already contains the part.
iffylens_set_part_can_be_gotten
  (Tagged {get, set}) whole {original, new}  =
  describe "when an part is present, set overwrites it"
    [ notEqual original new                           "test values allow difference to be seen"  
    , equal  (get          whole)    (Just original)  "`whole` contains original"
    , equal_ (get (set new whole))   (Just new)
    ]

-- Like `setting_part_with_same_value_leaves_whole_unchanged`. Difference
-- is that the law applies only when the whole already contains the
-- part.
iffylens_setting_part_with_same_value_leaves_whole_unchanged
  (Tagged {get, set}) whole {original} =
  describe "retrieving an part, then setting it back"
    [ equal  (get          whole)     (Just original)  "`whole` contains original"
    , equal_ (set original whole)     whole
    ]

iffylens_does_not_create
  (Tagged {get, set}) whole {new} = 
  describe "when an part is missing, `set` does nothing"
    [ equal (get          whole)      Nothing     "show part is missing"
    , equal (get (set new whole))     Nothing     "`get` still gets nothing"
    , equal      (set new whole)      whole       "nothing else changed"
    ]

-- Laws are separated into present/missing cases because some types
-- will have more than one for an part to be missing
    
iffyPartPresent lens whole inputValues = 
  describe "part present"
    [ iffylens_set_part_can_be_gotten
        lens whole inputValues

    , iffylens_setting_part_with_same_value_leaves_whole_unchanged
        lens whole inputValues

    , set_changes_only_the_given_part  -- Note we can reuse lens law
        lens whole inputValues
    ]

iffyPartMissing lens whole inputValues why = 
  describe ("part not present: " ++ why)
    [ iffylens_does_not_create 
        lens whole inputValues
    ]

---- SumLens laws

-- sumlens_get_set_round_trip {get, set} whole wrapped =
--   describe "if `get` succeeds, `set` recreates the sum type value"
--     [ equal_ (get whole)       (Just wrapped) 
--     , equal_ (set wrapped)     whole
--     ]

-- sumlens_set_get_round_trip {get, set} whole wrapped =
--   describe "`get` always retrieves what `set` sets"
--     [ equal_      (set wrapped)     whole
--     , equal_ (get (set wrapped))    (Just wrapped)
--     ]
    

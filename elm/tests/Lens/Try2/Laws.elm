module Lens.Try2.Laws exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

--- Lens laws

set_part_can_be_gotten {get, set} whole {new} =
  equal (get (set new whole)) new
    "set part can be gotten"

setting_part_with_same_value_leaves_whole_unchanged {get, set} whole = 
  equal (set (get whole) whole) whole
    "setting part with the same value leaves the whole unchanged"

set_changes_only_the_given_part {set} whole {overwritten, new} = 
  let
    a_direct_change =        whole |>                    set new
    change_that_overwrites = whole |> set overwritten |> set new
  in
    equal change_that_overwrites   a_direct_change
      "set changes only the given part (no counter, etc.)"

lens comment unwrappedLens whole inputValues = 
  describe comment
    [ set_part_can_be_gotten
        unwrappedLens whole inputValues

    , setting_part_with_same_value_leaves_whole_unchanged
        unwrappedLens whole 

    , set_changes_only_the_given_part
        unwrappedLens whole inputValues
    ]


--- WeakLens laws

-- Even where the laws have the same meaning as for lens, the type signatures
-- are too different.

-- set_part_can_be_gotten, but only for 
-- Difference is a check that it's only called with a whole that contains the element. 
weaklens_overwrites {get, set} whole {original, new}  =
  describe "when an element is present, set overwrites it"
    [ notEqual original new                           "correct test values"  
    , equal  (get          whole)    (Just original)  "correct `whole`"
    , equal_ (get (set new whole))   (Just new)
    ]

-- compare to setting_part_with_same_value_leaves_whole_unchanged
weaklens_setting_what_gotten_changes_nothing {get, set} whole {original} =
  describe "retrieving an element, then setting it back"
    [ equal  (get          whole)     (Just original)  "`get` gets original"
    , equal_ (set original whole)     whole
    ]

weaklens_does_not_create {get, set} whole {new} = 
  describe "when an element is missing, set does nothing"
    [ equal (get          whole)      Nothing     "show gets nothing"
    , equal (get (set new whole))     Nothing     "still gets nothing"
    , equal      (set new whole)      whole       "nothing else changed"
    ]

---- SumLens laws

sumlens_get_set_round_trip {get, set} whole wrapped =
  describe "if `get` succeeds, `set` recreates the sum type value"
    [ equal_ (get whole)       (Just wrapped) 
    , equal_ (set wrapped)     whole
    ]

sumlens_set_get_round_trip {get, set} whole wrapped =
  describe "`get` always retrieves what `set` sets"
    [ equal_      (set wrapped)     whole
    , equal_ (get (set wrapped))    (Just wrapped)
    ]
    

module Lens.Try2.Laws exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

--- Lens laws

set_part_can_be_gotten {get, set} whole part =
  equal (get (set part whole)) part
    "set part can be gotten"

setting_part_with_same_value_leaves_whole_unchanged {get, set} whole = 
  equal (set (get whole) whole) whole
    "setting part with the same value leaves the whole unchanged"


set_changes_only_the_given_part {set} whole overwritten part = 
  let
    a_direct_change =        whole |>                    set part
    change_that_overwrites = whole |> set overwritten |> set part
  in
    equal change_that_overwrites   a_direct_change
      "set changes only the given part (no counter, etc.)"
      

lens comment unwrappedLens whole part overwritten = 
  describe comment
    [ set_part_can_be_gotten unwrappedLens whole part
    , setting_part_with_same_value_leaves_whole_unchanged unwrappedLens whole
    , set_changes_only_the_given_part unwrappedLens whole overwritten part
    ]


--- WeakLens laws

-- Even where the laws have the same meaning as for lens, the type signatures
-- are too different.

-- Compare to set_part_can_be_gotten
weaklens_overwrites {get, set} whole original new  =
  describe "when an element is present, set overwrites it"
    [ equal  (get          whole)      (Just original)  "`get` gets original"
    , equal_ (get (set new whole))    (Just new)
    ]

weaklens_setting_what_gotten_changes_nothing {get, set} whole original =
  describe "retrieving an element, then setting it"
    [ equal  (get          whole)     (Just original)  "`get` gets original"
    , equal_ (set original whole)     whole
    ]

weaklens_does_not_create {get, set} whole new = 
  describe "when an element is missing, set does nothing"
    [ equal (get          whole)      Nothing     "show gets nothing"
    , equal (get (set new whole))     Nothing     "still gets nothing"
    , equal      (set new whole)      whole       "nothing else changed"
    ]


-- how_weaklens_is_like_lens comment unwrappedLens whole oldPart newPart overwrittenPart = 
--   describe comment
--     [ Laws.weaklens_overwrites unwrappedLens whole oldPart newPart
--     , Laws.weaklens_setting_what_gotten_changes_nothing unwrappedLens whole oldPart
--     , Laws.set_changes_only_the_given_part unwrappedLens  whole overwritten newPart
--     ]    

module Lens.Try2.Laws exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

set_part_can_be_gotten (get, set) whole part =
  equal (get (set part whole)) part
    "set part can be gotten"

setting_part_with_same_value_leaves_whole_unchanged (get, set) whole = 
  equal (set (get whole) whole) whole
    "setting part with the same value leaves the whole unchanged"


set_changes_only_the_given_part (get, set) whole overwritten part = 
  let
    a_direct_change =        whole |>                    set part
    change_that_overwrites = whole |> set overwritten |> set part
  in
    equal change_that_overwrites a_direct_change
      "set changes only the given part (no counter, etc.)"
      



lens comment lens whole part overwritten = 
  describe comment
    [ set_part_can_be_gotten lens whole part
    , setting_part_with_same_value_leaves_whole_unchanged lens whole
    , set_changes_only_the_given_part lens whole overwritten part
    ]
        

module Lens.Try1.LensTest exposing (..)

import Lens.Try1.Lens as Lens
import Lens.Try1.Tuple2 as Tuple2
import Lens.Try1.Tuple3 as Tuple3
import Lens.Try1.Tuple4 as Tuple4

import Test exposing (..)
import TestBuilders exposing (..)
import Dict exposing (Dict)

-- Basics 

-- Note: the getters and setters are tested via the laws
update =
  equal (Lens.update Tuple2.second negate ("foo", 1))    ("foo", -1)  "update - basic"

-- Laws
    
set_part_can_be_gotten lens whole part =
  let
    (get, set) = accessors lens
  in
    equal (get (set part whole)) part
      "set part can be gotten"

setting_part_with_same_value_leaves_whole_unchanged lens whole = 
  let
    (get, set) = accessors lens
  in
    equal (set (get whole) whole) whole
      "setting part with the same value leaves the whole unchanged"


set_changes_only_the_given_part lens whole overwritten part = 
  let
    (get, set) = accessors lens
    a_direct_change =        whole |>                    set part
    change_that_overwrites = whole |> set overwritten |> set part
  in
    equal change_that_overwrites a_direct_change
      "set changes only the given part (no counter, etc.)"
      

lensLaws comment lens whole part overwritten = 
  describe comment
    [ set_part_can_be_gotten lens whole part
    , setting_part_with_same_value_leaves_whole_unchanged lens whole
    , set_changes_only_the_given_part lens whole overwritten part
    ]
        
--- What obeys the lens laws?

recordsObeyLaws =
  let
    whole = { part = "OLD" } 
    lens = Lens.classic .part (\part whole -> {whole | part = part })
  in
    lensLaws "records"
      lens whole "NEW" "overwritten"
    
tuple2ObeysLaws =
  concat
  [ lensLaws "tuple2 - first "
      Tuple2.first ("OLD", 1) "NEW" "overwritten"
  , lensLaws "tuple2 - second"
      Tuple2.second (1, "OLD") "NEW" "overwritten"
  ]

tuple3ObeysLaws =
  concat
  [ lensLaws "tuple3 - first "
      Tuple3.first ("OLD", 2, 3) "NEW" "overwritten"
  , lensLaws "tuple3 - second"
      Tuple3.second (1, "OLD", 3) "NEW" "overwritten"
  , lensLaws "tuple3 - third"
      Tuple3.third (1, 2, "third") "NEW" "overwritten"
  ]

tuple4ObeysLaws =
  concat
  [ lensLaws "tuple4 - first "
      Tuple4.first ("OLD", 2, 3, 4) "NEW" "overwritten"
  , lensLaws "tuple4 - second"
      Tuple4.second (1, "OLD", 3, 4) "NEW" "overwritten"
  , lensLaws "tuple4 - third"
      Tuple4.third (1, 2, "third", 4) "NEW" "overwritten"
  , lensLaws "tuple4 - fourth"
      Tuple4.fourth (1, 2, 3, "fourth") "NEW" "overwritten"
  ]

recordPlusRecordObeysLaws =
  let
    a2b = Lens.classic .b (\newB a -> {a | b = newB })
    b2c = Lens.classic .c (\newC b -> {b | c = newC })
    a2c = Lens.compose a2b b2c 

    a = { b = { c = "OLD" } }
  in
    lensLaws "compose 2 lenses" a2c a "NEW" "overwritten"

{- This doesn't compile
      
dictPlusLensObeysLaws =
  let
    a2b = Lens.dict_2 "b"
    a2c = Lens.compose a2b Tuple2.second

    a = Dict.singleton "b" (1, "OLD") 
  in
    describe "dict + lens" 
      [ lensLaws "Just"    a2c a (Just "NEW")  (Just "overwritten")
      , lensLaws "Nothing" a2c a  Nothing      (Just "overwritten")
      ] 

-}

accessors lens = 
  (Lens.get lens, Lens.set lens)  

module Lens.LawTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Lens as Lens exposing (Lens)
import Lens.Tuple2 as Tuple2
import Lens.Tuple3 as Tuple3
import Lens.Tuple4 as Tuple4
import Dict exposing (Dict)
import Lens.OldVersions as OldVersions


set_part_can_be_gotten lens whole part =
  let
    (get, set) = (lens.get, lens.set)
  in
    equal (get (set part whole)) part
      "set part can be gotten"

-- Setting what you get changes produces the original value again
setting_part_with_same_value_leaves_whole_unchanged lens whole = 
  let
    (get, set) = (lens.get, lens.set)
  in
    equal (set (get whole) whole) whole
      "setting part with the same value leaves the whole unchanged"


set_changes_only_the_given_part lens whole overwritten part = 
  let
    (get, set) = (lens.get, lens.set)
    a_direct_change =        whole |>                    set part
    change_that_overwrites = whole |> set overwritten |> set part
  in
    equal change_that_overwrites a_direct_change
      "set changes only the given part (no counter, etc.)"

---

        
lens_laws comment lens whole part overwritten = 
    describe comment
      [ set_part_can_be_gotten lens whole part
      , setting_part_with_same_value_leaves_whole_unchanged lens whole
      , set_changes_only_the_given_part lens whole overwritten part
      ]

---       

records =
  let
    whole = { part = "OLD" } 
    lens = Lens.make .part (\part whole -> {whole | part = part })
  in
    lens_laws "records" lens whole "NEW" "overwritten"

-- Note that mixing strings and ints in the types implicitly checks that
-- the getters and setters are accessing the right element of the tuple.
      
tuple2 =
    concat
      [ lens_laws "tuple2 - first "
          Tuple2.first ("OLD", 1) "NEW" "overwritten"
      , lens_laws "tuple2 - second"
          Tuple2.second (1, "OLD") "NEW" "overwritten"
      ]

tuple3 =
    concat
      [ lens_laws "tuple3 - first "
          Tuple3.first ("OLD", 2, 3) "NEW" "overwritten"
      , lens_laws "tuple3 - second"
          Tuple3.second (1, "OLD", 3) "NEW" "overwritten"
      , lens_laws "tuple3 - third"
          Tuple3.third (1, 2, "OLD") "NEW" "overwritten"
      ]

tuple4 =
    concat
      [ lens_laws "tuple4 - first "
          Tuple4.first ("OLD", 2, 3, 4) "NEW" "overwritten"
      , lens_laws "tuple4 - second"
          Tuple4.second (1, "OLD", 3, 4) "NEW" "overwritten"
      , lens_laws "tuple4 - third"
          Tuple4.third (1, 2, "OLD", 4) "NEW" "overwritten"
      , lens_laws "tuple4 - fourth"
          Tuple4.fourth (1, 2, 3, "OLD") "NEW" "overwritten"
      ]

dict =
  let
    whole = Dict.singleton "key"  "OLD"
    lens = Lens.dict "key"
  in
    concat
      [ lens_laws "Dict/Just" lens whole (Just "NEW") (Just "overwritten")
      , lens_laws "Dict/Nothing" lens whole Nothing (Just "overwritten")
      ]


dict_version1 =
  let
    whole = Dict.singleton "key"  "OLD"
    lens = OldVersions.dictLens_1 "key"
  in
    concat
      [ lens_laws "DictV1/Just" lens whole (Just "NEW") (Just "overwritten")
      , lens_laws "DictV1/Nothing" lens whole Nothing (Just "overwritten")
      ]


dict_version2 =
  let
    whole = Dict.singleton "key"  "OLD"
    lens = OldVersions.dictLens_2 "key"
  in
    concat
      [ lens_laws "DictV2/Just" lens whole (Just "NEW") (Just "overwritten")
      , lens_laws "DictV2/Nothing" lens whole Nothing (Just "overwritten")
      ]



-------- Combining

lensPlusLens =
  let
    a2b = Lens.make .b (\newB a -> {a | b = newB })
    b2c = Lens.make .c (\newC b -> {b | c = newC })
    a2c = a2b |> Lens.plus b2c 

    a = { b = { c = "OLD" } }
  in
    lens_laws "compose 2 lenses" a2c a "NEW" "overwritten"

-- dictPlusDict =
--   let
--     a = Dict.singleton "b" (Dict.singleton "c" "OLD")
--     a2b = Lens.dict "b"
--     b2c = Tuple2.second

--     lens = a2b |> Lens.plus b2c
--   in
--     concat
--       [ lens_laws "dict+dict / Just" lens a (Just "NEW") (Just "overwritten")
--       , lens_laws "dict+dict / Nothing" lens a Nothing (Just "overwritten")
--       , lens_laws "dict+ / Just" lens Dict.empty (Just "NEW") (Just "overwritten")
--       , lens_laws "dict+ / Nothing" lens Dict.empty Nothing (Just "overwritten")
--       ] 


-- dictPlusLens =
--   let
--     a2b = Lens.dict "b"
--     a2c = a2b |> Lens.plus Tuple2.second

--     a = Dict.singleton "b" (1, "OLD") 
--   in
--     describe "dict + lens" 
--       [ lens_laws "Just"    a2c a (Just "NEW")  (Just "overwritten")
--       , lens_laws "Nothing" a2c a  Nothing      (Just "overwritten")
--       ] 
      

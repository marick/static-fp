module Lens.LawTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Lens as Lens exposing (Lens)
import Lens.Tuple2 as Tuple2
import Lens.Tuple3 as Tuple3
import Lens.Tuple4 as Tuple4
import Dict exposing (Dict)


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



-------- Combining

lensPlusLens =
  let
    a = { b = { c = "OLD" } }
    a2b = Lens.make .b (\newB a -> {a | b = newB })
    b2c = Lens.make .c (\newC b -> {b | c = newC })

    lens = a2b |> Lens.and b2c 
  in
    lens_laws "lens + lens" lens a "NEW" "overwritten"

lensPlusDict =
  let
    a = { b = Dict.singleton "c" "OLD" } 
    a2b = Lens.make .b (\newB a -> {a | b = newB })
    b2c = Lens.dict "c"

    lens = a2b |> Lens.and b2c 
  in
    concat
      [ lens_laws "lens + dict / Just" lens a (Just "NEW") (Just "overwritten")
      , lens_laws "lens + dict / Nothing" lens a Nothing (Just "overwritten")
      ] 

tripleLens =       
  let
    a = { b = { c = (1, "OLD") } }
    a2b = Lens.make .b (\newB a -> {a | b = newB })
    b2c = Lens.make .c (\newC b -> {b | c = newC })
    lens = a2b |> Lens.and b2c |> Lens.and Tuple2.second
  in
    lens_laws "triple lens" lens a "NEW" "overwritten"

dictplusLens =
  let
    a = Dict.singleton "b" (1, "OLD") 
    a2b = Lens.dict "b"

    lens = a2b |> Lens.and Tuple2.second
  in
    concat
      [ lens_laws "3 / Just" lens a (Just "NEW") (Just "overwritten")
      , lens_laws "3 / Nothing" lens a Nothing (Just "overwritten")
      ] 

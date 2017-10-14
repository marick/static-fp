module Lens.Try2.LensTest exposing (..)

import Lens.Try2.Lens as Lens exposing (Lens)
import Lens.Try2.Tuple2 as Tuple2

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Dict exposing (Dict)

-- Note: the getters and setters are tested via the laws
update =
  equal (Lens.update Tuple2.second negate ("foo", 1))    ("foo", -1)  "update - basic"

recordsObeyLaws =
  let
    whole = { part = "OLD" } 
    lens = Lens.lens .part (\part whole -> {whole | part = part })
  in
    Laws.lens "records"
      (Lens.ops lens) whole "NEW" "overwritten"
    
tuple2ObeysLaws =
  concat
  [ Laws.lens "tuple2 - first "
      (Lens.ops Tuple2.first) ("OLD", 1) "NEW" "overwritten"
  , Laws.lens "tuple2 - second"
      (Lens.ops Tuple2.second) (1, "OLD") "NEW" "overwritten"
  ]

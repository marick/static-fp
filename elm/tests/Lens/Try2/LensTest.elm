module Lens.Try2.LensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.Lens as Lens exposing (Lens)
import Lens.Try2.Tuple2 as Tuple2
import Lens.Try2.Tuple3 as Tuple3
import Lens.Try2.Tuple4 as Tuple4

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
      (unwrap lens) whole "NEW" "overwritten"
    
tuple2ObeysLaws =
  concat
  [ Laws.lens "tuple2 - first "
      (unwrap Tuple2.first) ("OLD", 1) "NEW" "overwritten"
  , Laws.lens "tuple2 - second"
      (unwrap Tuple2.second) (1, "OLD") "NEW" "overwritten"
  ]

tuple3ObeysLaws =
  concat
  [ Laws.lens "tuple3 - first "
      (unwrap Tuple3.first) ("OLD", 2, 3) "NEW" "overwritten"
  , Laws.lens "tuple3 - second"
      (unwrap Tuple3.second) (1, "OLD", 3) "NEW" "overwritten"
  , Laws.lens "tuple3 - third"
      (unwrap Tuple3.third) (1, 2, "third") "NEW" "overwritten"
  ]

tuple4ObeysLaws =
  concat
  [ Laws.lens "tuple4 - first "
      (unwrap Tuple4.first) ("OLD", 2, 3, 4) "NEW" "overwritten"
  , Laws.lens "tuple4 - second"
      (unwrap Tuple4.second) (1, "OLD", 3, 4) "NEW" "overwritten"
  , Laws.lens "tuple4 - third"
      (unwrap Tuple4.third) (1, 2, "third", 4) "NEW" "overwritten"
  , Laws.lens "tuple4 - fourth"
      (unwrap Tuple4.fourth) (1, 2, 3, "fourth") "NEW" "overwritten"
  ]


lensPlusLensObeysLaws =
  let
    a2b = Lens.lens .b (\newB a -> {a | b = newB })
    b2c = Lens.lens .c (\newC b -> {b | c = newC })
    a2c = a2b |> Lens.andThen b2c 

    a = { b = { c = "OLD" } }
  in
    Laws.lens "compose 2 lenses" (unwrap a2c) a "NEW" "overwritten"



-- support      

unwrap (T.ClassicLens lens) = lens


                       

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


-- Law tests

recordsObeyLaws =
  let
    lens = Lens.lens .part (\part whole -> {whole | part = part })
  in
    describe                                             "record lens laws"
      [ laws "records" lens { part = original }
      ]
    
tuple2ObeysLaws =
  describe                                               "tuple2 lens laws"
    [ laws "first " Tuple2.first   (original, 1)
    , laws "second" Tuple2.second  (1, original)
    ]

tuple3ObeysLaws =
  describe                                               "tuple3 lens laws"
    [ laws "first " Tuple3.first    (original, 2, 3)
    , laws "second" Tuple3.second   (1, original, 3)
    , laws "third"  Tuple3.third    (1, 2, original)
    ]

tuple4ObeysLaws =
  describe                                               "tuple4 lens laws"
    [ laws "first " Tuple4.first      (original, 2, 3, 4) 
    , laws "second" Tuple4.second     (1, original, 3, 4) 
    , laws "third"  Tuple4.third      (1, 2, original, 4) 
    , laws "fourth" Tuple4.fourth     (1, 2, 3, original) 
    ]


lensPlusLensObeysLaws =
  let
    a2b = Lens.lens .b (\newB a -> {a | b = newB })
    b2c = Lens.lens .c (\newC b -> {b | c = newC })
    a2c = a2b |> Lens.andThen b2c 

    a = { b = { c = original } }
  in
    describe                                             "lens + lens"
      [ laws "composition" a2c a 
      ]


-- support      


parts =
  { original = "OLD"
  , new = "NEW"
  , overwritten = "overwritten"
  }
original = parts.original 

laws : String -> Lens whole String -> whole -> Test
laws comment (T.ClassicLens lens) whole =
  Laws.lens comment lens whole parts
    
                       

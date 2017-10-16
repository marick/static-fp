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
    checkLaws "records" lens { part = Laws.original }
    
tuple2ObeysLaws =
  describe "tuple2 lens laws"
    [ checkLaws "first " Tuple2.first   (Laws.original, 1)
    , checkLaws "second" Tuple2.second  (1, Laws.original)
    ]

tuple3ObeysLaws =
  describe "tuple3 lens laws"
    [ checkLaws "first " Tuple3.first    (Laws.original, 2, 3)
    , checkLaws "second" Tuple3.second   (1, Laws.original, 3)
    , checkLaws "third"  Tuple3.third    (1, 2, Laws.original)
    ]

tuple4ObeysLaws =
  describe "tuple4 lens laws"
    [ checkLaws "first " Tuple4.first      (Laws.original, 2, 3, 4) 
    , checkLaws "second" Tuple4.second     (1, Laws.original, 3, 4) 
    , checkLaws "third"  Tuple4.third      (1, 2, Laws.original, 4) 
    , checkLaws "fourth" Tuple4.fourth     (1, 2, 3, Laws.original) 
    ]


lensPlusLensObeysLaws =
  let
    a2b = Lens.lens .b (\newB a -> {a | b = newB })
    b2c = Lens.lens .c (\newC b -> {b | c = newC })
    a2c = a2b |> Lens.andThen b2c 

    a = { b = { c = Laws.original } }
  in
    checkLaws "compose 2 lenses" a2c a 



-- support      

unwrap (T.ClassicLens lens) = lens

checkLaws comment wrappedLens whole =
  let
    parts =
      { original = Laws.original
      , new = Laws.new
      , overwritten = Laws.overwritten
      }
  in      
    Laws.lens comment (unwrap wrappedLens) whole parts
    

                       

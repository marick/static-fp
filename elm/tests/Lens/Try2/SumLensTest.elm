module Lens.Try2.SumLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.SumLens as SumLens exposing (SumLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Tuple
import Result

type Length
  = Raw Float Float
  | Annotated Float Float String
  | Colorful Float Float String

rawCase : SumLens Length (Float, Float)
rawCase  =
  let
    get point =
      case point of
        Raw x y -> Just (x, y)
        _ -> Nothing

    set (x, y) = Raw x y
  in
    SumLens.lens get set

-- Note: the getters and setters are tested indirectly, here and in the laws

update : Test
update =
  let
    negateBoth = Tuple.mapFirst negate >> Tuple.mapSecond negate
  in
    describe "update for SumLenses"
      [ equal (SumLens.update rawCase negateBoth
                 (Raw  2.0  3.0))
                 (Raw -2.0 -3.0)                  "lens matches constructor"
      , equal (SumLens.update rawCase negateBoth
                  (Annotated 2.0 3.0 "green"))
                  (Annotated 2.0 3.0 "green")     "wrong case"
      ]

-- -- Law tests
-- -- Note: these are for expressions that *produce* SumLenses.

sumObeys : Test
sumObeys =
  describe                                     "sumlens laws"
    (laws rawCase (Raw 1.0 3.5)   (1.0, 3.5))

okObeys : Test
okObeys = 
  describe                                     "sumlens laws: `ok`"
    (laws SumLens.ok (Ok "hello")  "hello")

sumPlusSumObeys : Test
sumPlusSumObeys =
  let
    a2c = SumLens.compose SumLens.ok rawCase
  in
    describe                                  "sumlens laws: sum + sum"
      (laws a2c (Ok <| Raw 3.0 12.0)   (3.0, 12.0))

-- -- Support

laws : SumLens whole wrapped -> whole -> wrapped -> List Test
laws (T.SumLens raw) whole wrapped =
  [ Laws.sumlens_get_set_round_trip raw whole wrapped
  , Laws.sumlens_set_get_round_trip raw whole wrapped
  ]

      

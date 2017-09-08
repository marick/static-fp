module IVFlat.Generic.LensTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (equal)
import IVFlat.Generic.Lens as Lens exposing (Lens)

suite : Test
suite =
  let
    record = {i = 3}
    lens = Lens.lens .i (\part whole -> { whole | i = part })
  in
    describe "lenses" 
      [ equal (Lens.get    lens        record)        3     "get"
      , equal (Lens.set    lens 5      record) { i =  5 }   "set"
      , equal (Lens.update lens negate record) { i = -3 }   "update"
      ]
       

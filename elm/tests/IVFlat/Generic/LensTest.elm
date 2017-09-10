module IVFlat.Generic.LensTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (equal)
import IVFlat.Generic.Lens as Lens exposing (Lens)

suite : Test
suite =
  let
    record = {i = 3}
    aLens = Lens.lens .i (\part whole -> { whole | i = part })
  in
    describe "lenses" 
      [ equal (Lens.get    aLens        record)        3     "get"
      , equal (Lens.set    aLens 5      record) { i =  5 }   "set"
      , equal (Lens.update aLens negate record) { i = -3 }   "update"
      ]
       

module IVFlat.Generic.LensTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import TestUtil exposing (..)
import IVFlat.Generic.Lens as Lens exposing (Lens)

type alias Record = { i : Int }

suite : Test
suite =
  let
    r = {i = 3}
    l = Lens.lens .i (\part whole -> { whole | i = part })
    check actual expected comment =
      test comment <| \_ ->
        actual |> Expect.equal expected
  in
    describe "lenses" 
      [ check (Lens.get    l        r)        3     "get"
      , check (Lens.set    l 5      r) { i =  5 }   "set"
      , check (Lens.update l negate r) { i = -3 }   "update"
      ]
       

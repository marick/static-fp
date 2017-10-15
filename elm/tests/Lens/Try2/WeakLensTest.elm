module Lens.Try2.WeakLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Array


-- Note: the getters and setters are tested via the laws
update =
  let
    lens = WeakLens.array 1
  in
    describe "update for WeakLenses"
      [ equal_ (WeakLens.update lens negate
                  (Array.fromList [10,  20]))
                  (Array.fromList [10, -20])
      , equal_ (WeakLens.update lens negate
                  (Array.fromList [10]))
                  (Array.fromList [10])
      ]


arrayObeysLensLaws =
  let
    whole = Array.fromList [ "OLD" ] 
    found = WeakLens.array 0
    fails = WeakLens.array 33
  in
    describe "Dict and lens laws "
      [ Laws.weaklens_overwrites (unwrap found) whole "OLD" "NEW"
      , Laws.weaklens_does_not_create (unwrap fails) whole "NEW"
      ]    
      




-- Support


unwrap (T.WeakLens lens) = lens

      

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


-- arrayObeysLensLaws =
--   let
--     whole = Array.fromList [ "OLD" ] 
--     found = WeakLens.array 0
--     fails = WeakLens.array 33
--   in
--     describe "Dict and lens laws "
--       [ -- This is the important difference
--         Laws.weaklens_does_not_create (unwrap fails) whole "NEW"

--       , Laws.weaklens_overwrites (unwrap found) whole "OLD" "NEW"
--       , Laws.weaklens_setting_what_gotten_changes_nothing (unwrap found) whole "OLD"
--       , Laws.set_changes_only_the_given_part (unwrap found) whole "Overwritten" "NEW"
--       ]    
      




-- Support


unwrap (T.WeakLens lens) = lens

      

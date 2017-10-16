module Lens.Try2.WeakLensTest exposing (..)

import Lens.Try2.Types as T
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try2.Laws as Laws
import Array


-- Note: the getters and setters are tested via the laws
update : Test
update =
  let
    lens = WeakLens.array 1
  in
    describe "update for WeakLenses"
      [ equal (WeakLens.update lens negate
                 (Array.fromList [10,  20]))
                 (Array.fromList [10, -20])    "value exists at focus"
      , equal (WeakLens.update lens negate
                  (Array.fromList [10]))
                  (Array.fromList [10])        "no value at focus"
      ]


arrayObeysLensLaws : Test
arrayObeysLensLaws =
  let
    whole = Array.fromList [ parts.original ] 
    found = WeakLens.array 0
    fails = WeakLens.array 33
  in
    describe                                   "arrays obey lens laws" 
      (laws found fails whole)
      




-- Support

parts =
  { original = 'o'
  , new = 'n'
  , overwritten = '-'
  }
                           
laws : WeakLens whole Char -> WeakLens whole Char -> whole -> List Test
laws (T.WeakLens found) (T.WeakLens fails) whole =
  [ -- This is the important difference
    Laws.weaklens_does_not_create fails whole parts
        
  , Laws.weaklens_overwrites found whole parts
  , Laws.weaklens_setting_what_gotten_changes_nothing found whole parts
  , Laws.set_changes_only_the_given_part found whole parts
  ]    

      

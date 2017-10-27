module Lens.Try3.Util exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

import Lens.Try3.Laws as Laws
import Lens.Try3.Lens as Lens
import List.Extra as List

upt lens whole expected =
  equal_ (Lens.update lens negate whole) expected

classicLawSupport =
  let 
    original = "OLD"
    parts =
      { original = original
      , new = "NEW"
      , overwritten = "overwritten"
      }
    legal lens whole =
      Laws.classic lens whole parts (toString whole)
  in
    (original, legal)


-- Same as classic law support, but parts are permutations of [Nothing, Just a]

maybeCombinations original overwritten new =
  let
    maybes a =
      [Nothing, Just a]
    tuples =
      List.lift3 (,,) (maybes original) (maybes overwritten) (maybes new)
    recordify (a, b, c) =
      { original = a, overwritten = b, new = c }
  in
    List.map recordify tuples

upsertLensObeysClassicLaws {lens, focusMissing, makeFocus} ({original} as parts) =
  let
    whole = 
      case original of
        Nothing -> focusMissing
        Just a -> makeFocus a
  in 
    Laws.classic lens whole parts (toString parts)
                     

humbleLawSupport =
  let 
    original = '1'
    parts =
      { original = original
      , overwritten = '-'
      , new = '2'
      }
    present lens whole =
      Laws.humblePartPresent lens whole parts
    missing lens whole why = 
      Laws.humblePartMissing lens whole parts why
  in
    (original, present, missing)

      



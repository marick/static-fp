module Lens.Try3.Util exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)

import Lens.Try3.Laws as Laws
import Lens.Try3.Lens as Lens

upt lens whole expected =
  equal_ (Lens.update lens negate whole) expected

iffyLawSupport =
  let 
    original = '1'
    parts =
      { original = original
      , overwritten = '-'
      , new = '2'
      }
    present lens whole =
      Laws.iffyPartPresent lens whole parts
    missing lens whole why = 
      Laws.iffyPartMissing lens whole parts why
  in
    (original, present, missing)

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

-- Same as classic law support, but using `Just` when inserting elements.
upsertLawSupport =
  let
    original = "OLD"
    parts =
      { original = Just original
      , new = Just "NEW"
      , overwritten = Just "overwritten"
      }
    legal lens whole =
      Laws.classic lens whole parts (toString whole)
  in
    (original, legal)

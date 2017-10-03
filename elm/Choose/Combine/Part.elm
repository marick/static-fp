module Choose.Combine.Part exposing (..)

import Choose.Part as Part exposing (Part)
import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Case as Case exposing (Case)

toMaybePart : Part a b -> MaybePart a b
toMaybePart part =
  MaybePart.make
    (part.get >> Just)
    part.set

module Choose.Combine.Part exposing (..)

import Choose.Part as Part exposing (Part)
import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Combine.MaybePart as MaybePart
import Choose.Case as Case exposing (Case)

appendMaybePart : Part a b -> MaybePart b c -> MaybePart a c
appendMaybePart a2b b2c =
  MaybePart.append (MaybePart.fromPart a2b) b2c
                      
nextMaybePart : MaybePart b c -> Part a b -> MaybePart a c
nextMaybePart = flip appendMaybePart

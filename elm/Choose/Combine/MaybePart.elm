module Choose.Combine.MaybePart exposing (..)

import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Part as Part exposing (Part)
import Choose.Case as Case exposing (Case)

fromPart : Part a b -> MaybePart a b
fromPart a2b =
  MaybePart.make
    (a2b.get >> Just)
    a2b.set

fromCase : Case a b -> MaybePart a b
fromCase a2b = 
  MaybePart.make
    a2b.get
    (\ b _ -> a2b.set b)

appendPart : MaybePart a b -> Part b c -> MaybePart a c
appendPart a2b b2c =
  MaybePart.append a2b (fromPart b2c)

nextPart : Part b c -> MaybePart a b -> MaybePart a c
nextPart = flip appendPart


appendCase : MaybePart a b -> Case b c -> MaybePart a c
appendCase a2b b2c =
  MaybePart.append a2b (fromCase b2c)

nextCase : Case b c -> MaybePart a b -> MaybePart a c
nextCase = flip appendCase
           

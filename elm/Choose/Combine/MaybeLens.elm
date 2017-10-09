module Choose.Combine.MaybeLens exposing (..)
import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Choose.Lens as Lens exposing (Lens)
import Choose.Case as Case exposing (Case)

fromLens : Lens a b -> MaybeLens a b
fromLens a2b =
  MaybeLens.make
    (a2b.get >> Just)
    a2b.set

fromCase : Case a b -> MaybeLens a b
fromCase a2b = 
  MaybeLens.make
    a2b.get
    (\ b _ -> a2b.set b)

appendLens : MaybeLens a b -> Lens b c -> MaybeLens a c
appendLens a2b b2c =
  MaybeLens.append a2b (fromLens b2c)

nextLens : Lens b c -> MaybeLens a b -> MaybeLens a c
nextLens = flip appendLens


appendCase : MaybeLens a b -> Case b c -> MaybeLens a c
appendCase a2b b2c =
  MaybeLens.append a2b (fromCase b2c)

nextCase : Case b c -> MaybeLens a b -> MaybeLens a c
nextCase = flip appendCase
           

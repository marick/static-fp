module Choose.Combine.Lens exposing (..)

import Choose.Lens as Lens exposing (Lens)
import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Choose.Combine.MaybeLens as MaybeLens
import Choose.Case as Case exposing (Case)

appendMaybeLens : Lens a b -> MaybeLens b c -> MaybeLens a c
appendMaybeLens a2b b2c =
  MaybeLens.append (MaybeLens.fromLens a2b) b2c
                      
nextMaybeLens : MaybeLens b c -> Lens a b -> MaybeLens a c
nextMaybeLens = flip appendMaybeLens

module Lens.Try2.Operators exposing (..)

import Lens.Try2.Lens as Lens exposing (Lens)
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)
import Lens.Try2.SumLens as SumLens exposing (SumLens)

(....) : Lens a b -> Lens b c -> Lens a c
(....) = Lens.compose 
infixl 0 ....    

(...:) : Lens a b -> UpsertLens b c -> UpsertLens a c
(...:) = Lens.composeUpsert
infixl 0 ...:    

(+..+) : SumLens a b -> SumLens b c -> SumLens a c
(+..+) = SumLens.compose
infixl 0 +..+

(^..^) : UpsertLens a b -> UpsertLens b c -> WeakLens a c
(^..^) = UpsertLens.compose
infixl 0 ^..^


(^...) : UpsertLens a b -> Lens b c -> WeakLens a c
(^...) = UpsertLens.composeLens
infixl 0 ^...


(~..~) : WeakLens a b -> WeakLens b c -> WeakLens a c
(~..~) = WeakLens.compose
infixl 0 ~..~





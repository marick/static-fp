module Lens.Try3.Compose.Operators exposing (..)

import Lens.Try3.Lens exposing (ClassicLens, UpsertLens, IffyLens, OneCaseLens)
import Lens.Try3.Compose as Compose


(....) : ClassicLens a b -> ClassicLens b c -> ClassicLens a c
(....) = Compose.classicAndClassic
infixl 0 ....    

(...^) : ClassicLens a b -> UpsertLens b c -> UpsertLens a c
(...^) = Compose.classicAndUpsert
infixl 0 ...^    

(^...) : UpsertLens a b -> ClassicLens b c -> IffyLens a c
(^...) = Compose.upsertAndClassic
infixl 0 ^...

(?..?) : IffyLens a b -> IffyLens b c -> IffyLens a c
(?..?) = Compose.iffyAndIffy
infixl 0 ?..?


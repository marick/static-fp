module Lens.Try3.Compose.Operators exposing (..)

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose


(....) : Lens.Classic a b -> Lens.Classic b c -> Lens.Classic a c
(....) = Compose.classicAndClassic
infixl 0 ....    

(...^) : Lens.Classic a b -> Lens.Upsert b c -> Lens.Upsert a c
(...^) = Compose.classicAndUpsert
infixl 0 ...^    

(^...) : Lens.Upsert a b -> Lens.Classic b c -> Lens.Iffy a c
(^...) = Compose.upsertAndClassic
infixl 0 ^...

(?..?) : Lens.Iffy a b -> Lens.Iffy b c -> Lens.Iffy a c
(?..?) = Compose.iffyAndIffy
infixl 0 ?..?


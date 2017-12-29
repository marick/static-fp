module Lens.Final.Operators exposing (..)

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Compose


(..>>) : Lens.Classic a b -> Lens.Classic b c -> Lens.Classic a c
(..>>) = Compose.classicAndClassic
infixl 0 ..>>    

(.^>>) : Lens.Classic a b -> Lens.Upsert b c -> Lens.Upsert a c
(.^>>) = Compose.classicAndUpsert
infixl 0 .^>>

(.?>>) : Lens.Classic a b -> Lens.Humble b c -> Lens.Humble a c
(.?>>) = Compose.classicAndHumble
infixl 0 .?>>

(^.>>) : Lens.Upsert a b -> Lens.Classic b c -> Lens.Humble a c
(^.>>) = Compose.upsertAndClassic
infixl 0 ^.>>

(??>>) : Lens.Humble a b -> Lens.Humble b c -> Lens.Humble a c
(??>>) = Compose.humbleAndHumble
infixl 0 ??>>

(?.>>) : Lens.Humble a b -> Lens.Classic b c -> Lens.Humble a c
(?.>>) = Compose.humbleAndClassic
infixl 0 ?.>>

(|.>>) : Lens.OneCase a b -> Lens.Classic b c -> Lens.Humble a c
(|.>>) = Compose.oneCaseAndClassic
infixl 0 |.>>

(!!>>) : Lens.Path a b -> Lens.Path b c -> Lens.Path a c
(!!>>) = Compose.pathAndPath
infixl 0 !!>>


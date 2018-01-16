module Lens.Final.Operators exposing (..)

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Compose

{- Naming convention

   If there are N lens types, there are NxN ways to compose them.
   Here's a subset of those ways. The naming convention is that
   each operator is of the form `xx>>`, where the `x` encodes
   the type on either the left- or right-hand side and `>>` is
   supposed to remind you of function composition.

   `.` is a Classic lens. Think of Elm's `.field` notation for
       records.

   `^` is an Upsert lens. The symbol points up.

   `?` is a Humble Lens. The symbol is supposed to indicate
       the lens is tentative about `set`, not as assertive
       as Classic and Upsert lenses are.

   '|' is a OneCase lens. The vertical bar hopes to remind
       you of the common notation for the `OR` operator in
       programming languages. The value of a sum type is
       case 1 or case 2 or case 3.

   '!' is a Path lens. Because such are usually used to
       report errors, the excitement of an exclamation point
       seems appropriate.

  Fortunately, the compiler will tell you if you choose the
  wrong operator for the left and right lenses.
-}   


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


module Choose.Operators exposing (..)

import Choose.Lens as Lens exposing (Lens)
import Choose.Combine.Lens as Lens
import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Choose.Combine.MaybeLens as MaybeLens 
import Choose.Case as Case exposing (Case)
import Choose.Combine.Case as Case 

       
(....) : Lens a b -> Lens b c -> Lens a c
(....) = Lens.append
infixl 0 ....
       
(~..~) : MaybeLens a b -> MaybeLens b c -> MaybeLens a c
(~..~) = MaybeLens.append
infixl 0 ~..~
       
(~...) : MaybeLens a b -> Lens b c -> MaybeLens a c
(~...) = MaybeLens.appendLens
infixl 0 ~...
       
(~..>) : MaybeLens a b -> Case b c -> MaybeLens a c
(~..>) = MaybeLens.appendCase
infixl 0 ~..>
       
(>..>) : Case  a b -> Case b c -> Case a c
(>..>) = Case.append
infixl 0 >..>
       

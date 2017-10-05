module Choose.Operators exposing (..)

import Choose.Part as Part exposing (Part)
import Choose.Combine.Part as Part
import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Combine.MaybePart as MaybePart 
import Choose.Case as Case exposing (Case)
import Choose.Combine.Case as Case 

       
(....) : Part a b -> Part b c -> Part a c
(....) = Part.append
infixl 0 ....
       
(~..~) : MaybePart a b -> MaybePart b c -> MaybePart a c
(~..~) = MaybePart.append
infixl 0 ~..~
       
(~...) : MaybePart a b -> Part b c -> MaybePart a c
(~...) = MaybePart.appendPart
infixl 0 ~...
       
(~..>) : MaybePart a b -> Case b c -> MaybePart a c
(~..>) = MaybePart.appendCase
infixl 0 ~..>
       
(>..>) : Case  a b -> Case b c -> Case a c
(>..>) = Case.append
infixl 0 >..>
       

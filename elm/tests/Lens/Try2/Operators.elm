module Lens.Try2.Operators exposing (..)

import Lens.Try2.Lens as Lens exposing (Lens)
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)

(....) : Lens a b -> Lens b c -> Lens a c
(....) = Lens.append 

infixl 0 ....    



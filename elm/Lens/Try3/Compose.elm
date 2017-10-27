module Lens.Try3.Compose exposing (..)


import Tagged exposing (Tagged(..))
import Lens.Try3.Lens as Lens 

{-          Conversions               -}

classicToHumble : Lens.Classic big small -> Lens.Humble big small
classicToHumble (Tagged lens) = 
  Lens.humble (lens.get >> Just) lens.set

upsertToHumble : Lens.Upsert big small -> Lens.Humble big small
upsertToHumble (Tagged lens) =
  let
    set_ small big =
      lens.set (Just small) big
  in
    Lens.humble lens.get (Lens.addGuard set_ lens.get)
      
oneCaseToHumble : Lens.OneCase big small -> Lens.Humble big small
oneCaseToHumble (Tagged lens) =
  let
    set_ small _ =
      lens.set small
  in
    Lens.humble lens.get (Lens.addGuard set_ lens.get)


{-          Composition               -}

      

classicAndClassic : Lens.Classic a b -> Lens.Classic b c -> Lens.Classic a c
classicAndClassic (Tagged a2b) (Tagged b2c) =
  Lens.classic
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

-- We can use the `compose` helpers here because an `Lens.Upsert` is just
-- a classic lens with the `part` type narrowed to `Maybe part`.
classicAndUpsert : Lens.Classic a b -> Lens.Upsert b c -> Lens.Upsert a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  Lens.upsert2
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

upsertAndClassic : Lens.Upsert a b -> Lens.Classic b c -> Lens.Humble a c
upsertAndClassic a2b b2c =
  humbleAndHumble
    (upsertToHumble a2b)
    (classicToHumble b2c)
    
humbleAndHumble : Lens.Humble a b -> Lens.Humble b c -> Lens.Humble a c
humbleAndHumble (Tagged a2b) (Tagged b2c) =
  let 
    get a =
      case a2b.get a of
        Nothing -> Nothing
        Just b -> b2c.get b
                  
    set c a =
      case a2b.get a of
        Nothing ->
          a
        Just b ->
          a2b.set (b2c.set c b) a
  in
    Lens.humble get set


-----------------

composeLensGet : (a -> b) -> (b -> c) -> (a -> c)
composeLensGet getB getC =
  getB >> getC

composeLensSet : (a -> b) -> (c -> b -> b) -> (b -> a -> a) -> (c -> a -> a)
composeLensSet getB setB setA c a =
  setA (getB a |> setB c) a

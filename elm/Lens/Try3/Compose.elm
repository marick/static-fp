module Lens.Try3.Compose exposing (..)


import Tagged exposing (Tagged(..))
import Lens.Try3.Lens as Lens exposing (ClassicLens, UpsertLens, IffyLens, OneCaseLens)

{-          Conversions               -}

classicToIffy : ClassicLens big small -> IffyLens big small
classicToIffy (Tagged lens) = 
  Lens.iffy (lens.get >> Just) lens.set

upsertToIffy : UpsertLens big small -> IffyLens big small
upsertToIffy (Tagged lens) =
  let
    set_ small big =
      lens.set (Just small) big
  in
    Lens.iffy lens.get (Lens.addGuard set_ lens.get)
      
oneCaseToIffy : OneCaseLens big small -> IffyLens big small
oneCaseToIffy (Tagged lens) =
  let
    set_ small _ =
      lens.set small
  in
    Lens.iffy lens.get (Lens.addGuard set_ lens.get)


{-          Composition               -}

      

classicAndClassic : ClassicLens a b -> ClassicLens b c -> ClassicLens a c
classicAndClassic (Tagged a2b) (Tagged b2c) =
  Lens.classic
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

-- We can use the `compose` helpers here because an `UpsertLens` is just
-- a classic lens with the `part` type narrowed to `Maybe part`.
classicAndUpsert : ClassicLens a b -> UpsertLens b c -> UpsertLens a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  Lens.upsert2
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

upsertAndClassic : UpsertLens a b -> ClassicLens b c -> IffyLens a c
upsertAndClassic a2b b2c =
  iffyAndIffy
    (upsertToIffy a2b)
    (classicToIffy b2c)
    
iffyAndIffy : IffyLens a b -> IffyLens b c -> IffyLens a c
iffyAndIffy (Tagged a2b) (Tagged b2c) =
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
    Lens.iffy get set


-----------------

composeLensGet : (a -> b) -> (b -> c) -> (a -> c)
composeLensGet getB getC =
  getB >> getC

composeLensSet : (a -> b) -> (c -> b -> b) -> (b -> a -> a) -> (c -> a -> a)
composeLensSet getB setB setA c a =
  setA (getB a |> setB c) a

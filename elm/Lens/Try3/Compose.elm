module Lens.Try3.Compose exposing (..)


import Tagged exposing (Tagged(..))
import Lens.Try3.Lens as Lens
import Lens.Try3.Helpers as H

{-          Conversions               -}

classicToHumble : Lens.Classic big small -> Lens.Humble big small
classicToHumble (Tagged lens) = 
  Lens.humble (lens.get >> Just) lens.set

upsertToHumble : Lens.Upsert big small -> Lens.Humble big small
upsertToHumble (Tagged lens) =
  let
    set small big =
      lens.set (Just small) big
  in
    Lens.humble lens.get (H.guardedSet lens.get set)
      
oneCaseToHumble : Lens.OneCase big small -> Lens.Humble big small
oneCaseToHumble (Tagged lens) =
  let
    set small _ =
      lens.set small
  in
    Lens.humble lens.get (H.guardedSet lens.get set )


humbleToError : (big -> err)
              -> Lens.Humble big small
              -> Lens.Error err big small
humbleToError errMaker (Tagged lens) =
  let 
    get big =
      case lens.get big of
        Just x -> Ok x
        Nothing -> Err <| errMaker big
  in
    Tagged
      { get = get
      , set = lens.set
      , update = lens.update
      }

      

{-          Composition               -}

      

classicAndClassic : Lens.Classic a b -> Lens.Classic b c -> Lens.Classic a c
classicAndClassic (Tagged a2b) (Tagged b2c) =
  Lens.classic
    (composeGets a2b.get b2c.get)
    (composeSets a2b.get b2c.set a2b.set)

-- We can use the `compose` helpers here because an `Lens.Upsert` is just
-- a classic lens with the `part` type narrowed to `Maybe part`.
classicAndUpsert : Lens.Classic a b -> Lens.Upsert b c -> Lens.Upsert a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  Lens.upsert2
    (composeGets a2b.get b2c.get)
    (composeSets a2b.get b2c.set a2b.set)

classicAndHumble : Lens.Classic a b -> Lens.Humble b c -> Lens.Humble a c
classicAndHumble a2b b2c = 
  humbleAndHumble (classicToHumble a2b) b2c

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

-- For completeness, make some tests      
humbleAndClassic : Lens.Humble a b -> Lens.Classic b c -> Lens.Humble a c
humbleAndClassic a2b b2c = 
  humbleAndHumble a2b (classicToHumble b2c)

oneCaseAndClassic : Lens.OneCase a b -> Lens.Classic b c -> Lens.Humble a c
oneCaseAndClassic a2b b2c =
  humbleAndHumble
    (oneCaseToHumble a2b)
    (classicToHumble b2c)

-----------------

errorAndError : Lens.Error err a b -> Lens.Error err b c -> Lens.Error err a c
errorAndError (Tagged a2b) (Tagged b2c) =
  let 
    get a =
      case a2b.get a of
        Ok b -> b2c.get b
        Err e -> Err e
                  
    set c a =
      case a2b.get a of
        Ok b ->
          a2b.set (b2c.set c b) a
        Err _ -> a
  in
    Lens.error get set

-----------------

composeGets : (a -> b) -> (b -> c) -> (a -> c)
composeGets aGetB aGetC =
  aGetB >> aGetC

composeSets : (a -> b) -> (c -> b -> b) -> (b -> a -> a) -> (c -> a -> a)
composeSets aGetB bSetC aSetB c a =
  aSetB (aGetB a |> bSetC c) a


    

-----------------
-- Identities are used in the chapter on monoids.

classicIdentity : Lens.Classic big big
classicIdentity =
  let
    set newBig _ = newBig
  in
    Lens.classic identity set


humbleIdentity : Lens.Humble big big
humbleIdentity =
  let
    set newBig _ = newBig
  in
    Lens.humble (identity >> Just) set
      

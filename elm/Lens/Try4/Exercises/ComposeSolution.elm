module Lens.Try4.Exercises.ComposeSolution exposing (..)


import Tagged exposing (Tagged(..))
import Lens.Try4.Lens as Lens exposing (Classic, Humble, Upsert)



{-                 Conversions       -}

classicToHumble : Classic big small -> Humble big small
classicToHumble (Tagged lens) = 
  Lens.humble (lens.get >> Just) lens.set


upsertToHumble : Upsert big small -> Humble big small
upsertToHumble (Tagged lens) =
  let
    set small big =
      case lens.get big of
        Nothing ->
          big
        Just _ ->
          lens.set (Just small) big 
  in
    Lens.humble lens.get set


{-                 Combinations       -}

humbleAndHumble : Humble a b -> Humble b c -> Humble a c
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

upsertAndClassic : Upsert a b -> Classic b c -> Humble a c
upsertAndClassic a2b b2c =
  humbleAndHumble
    (upsertToHumble a2b)
    (classicToHumble b2c)
    
classicAndUpsert : Classic a b -> Upsert b c -> Upsert a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  let
    get =
      a2b.get >> b2c.get
      
    set small big =
      a2b.set (a2b.get big |> b2c.set small) big
  in
    Lens.upsert2 get set
  
classicAndClassic : Classic a b -> Classic b c -> Classic a c
classicAndClassic (Tagged a2b) (Tagged b2c) =
  let
    get =
      a2b.get >> b2c.get
      
    set small big =
      a2b.set (a2b.get big |> b2c.set small) big
  in
    Lens.classic get set
  
      

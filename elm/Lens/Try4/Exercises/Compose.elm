module Lens.Try4.Exercises.Compose exposing (..)

import Tagged exposing (Tagged(..))
import Lens.Try4.Lens as Lens exposing (Classic, Humble, Upsert)

oopsie = "Elm doesn't like files that contain no definitions"

{-                 Conversions       -}

{-
classicToHumble : Classic big small -> Humble big small
classicToHumble (Tagged lens) = 
  Lens.humble ...
-}

{-
upsertToHumble : Upsert big small -> Humble big small
upsertToHumble (Tagged lens) =
  let
    ...
  in
    Lens.humble ...
-}

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

{-
upsertAndClassic : Upsert a b -> Classic b c -> Humble a c
upsertAndClassic a2b b2c =
  ...
-}
    
{-
classicAndUpsert : Classic a b -> Upsert b c -> ???? a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  ...  
-}

{-
classicAndClassic : Classic a b -> Classic b c -> Classic a c
classicAndClassic (Tagged a2b) (Tagged b2c) =
  ...
-}

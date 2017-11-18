module Lens.Try3.Exercises.Compose exposing (..)

import Tagged exposing (Tagged(..))
import Lens.Try3.Lens as Lens exposing (Classic, Humble, Upsert)

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

{-
humbleAndHumble : Humble a b -> Humble b c -> Humble a c
humbleAndHumble (Tagged a2b) (Tagged b2c) =
  ...
-}

{-
upsertAndClassic : Upsert a b -> Classic b c -> Humble a c
upsertAndClassic a2b b2c =
  ...
-}
    
{-
classicAndUpsert : Classic a b -> Upsert b c -> Upsert a c
classicAndUpsert (Tagged a2b) (Tagged b2c) =
  ...  
-}

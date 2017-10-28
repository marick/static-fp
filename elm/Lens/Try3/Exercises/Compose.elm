module Lens.Try3.Exercises.Compose exposing (..)


import Tagged exposing (Tagged(..))
import Lens.Try3.Helpers as H

{- By radically widening the types, we can have `get`, `set`, and
   `update` that work with different kinds of lenses.
-}
type alias Generic getter setter updater =
  { get : getter
  , set : setter
  , update : updater
  }

get : Tagged tag (Generic getter setter updater) -> getter
get (Tagged lens) =
  lens.get

set : Tagged tag (Generic getter setter updater) -> setter
set (Tagged lens) =
  lens.set

update : Tagged tag (Generic getter setter updater) -> updater
update (Tagged lens) =
  lens.update


{-                  Classic Lenses             -}

type ClassicTag = ClassicTag IsUnused
type alias Classic big small =
  Tagged ClassicTag
    { get : big -> small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

classic : (big -> small) -> (small -> big -> big) -> Classic big small
classic get set =
  let 
    update f big =
      get big |> f |> flip set big
  in
    Tagged { get = get, set = set, update = update }

      
      
{-                  Upsert Lenses               -}

type UpsertTag = UpsertTag IsUnused
type alias Upsert big small =
  Tagged UpsertTag
    { get : big -> Maybe small
    , set : Maybe small -> big -> big
    , update : (small -> small) -> big -> big
    }

upsert : (big -> Maybe small)
      -> (small -> big -> big)
      -> (big -> big)          -- separate `delete` function
      -> Upsert big small
upsert get upserter remove =
  let
    set_ maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upserter val
  in
    upsert2 get set_

upsert2 : (big -> Maybe small)
        -> (Maybe small -> big -> big)
        -> Upsert big small
upsert2 get set =           
  let
    update f = H.guardedUpdate get set (f >> Just)
  in
    Tagged
    { get = get
    , set = set
    , update = update
    }

      

{-                  Humble Lenses               -}

type HumbleTag = HumbleTag IsUnused
type alias Humble big small =
  Tagged HumbleTag
    { get : big -> Maybe small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

humble : (big -> Maybe small)
       -> (small -> big -> big)
       -> Humble big small
humble get set =
  Tagged
  { get = get
  , set = set
  , update = H.guardedUpdate get set
  }


{-                 Conversions       -}

-- classicToHumble : Classic big small -> Humble big small
-- classicToHumble (Tagged lens) = 


-- upsertToHumble : Upsert big small -> Humble big small
-- upsertToHumble (Tagged lens) =


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
    humble get set

-- upsertAndClassic : Upsert a b -> Classic b c -> Humble a c
-- upsertAndClassic a2b b2c = ...
    
-- classicAndUpsert : Classic a b -> Upsert b c -> ???? a c
-- classicAndUpsert (Tagged a2b) (Tagged b2c) = ...
  

{-                 Util                        -}

type IsUnused = IsUnused IsUnused

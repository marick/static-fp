module Lens.Try3.Lens exposing (..)


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

-- A generic type for all lenses whose getters return `Maybe`.
type alias GenericMaybe big small setter updater =
  Generic (big -> Maybe small) setter updater 
    
hasJust : Tagged tag (GenericMaybe big small setter updater)
       -> big -> Bool
hasJust (Tagged lens) whole = 
  case lens.get whole of
    Nothing -> False
    _ -> True
  
    

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

getWithDefault : Tagged tag (GenericMaybe big small setter updater)
               -> small -> big -> Maybe small    
getWithDefault (Tagged lens) default big =
  case lens.get big of
    Nothing -> Just default
    actual -> actual


               
updateWithDefault : Upsert big small -> small -> (small -> small)
                  -> big -> big
updateWithDefault (Tagged lens) default f big =
  let
    gotten =
      case lens.get big of
        Nothing -> default
        (Just small) -> small
  in
    lens.set (f gotten |> Just) big
      

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


{-                  OneCase Lenses               -}

type OneCaseTag = OneCaseTag IsUnused
type alias OneCase big small =
  Tagged OneCaseTag
    { get : big -> Maybe small
    , set : small -> big
    , update : (small -> small) -> big -> big
    }

oneCase : (big -> Maybe small)
        -> (small -> big)
        -> OneCase big small
oneCase get set =
  let
    update_ f big =
      case get big of
        Nothing ->
          big
        Just small ->
          set (f small)
  in
    Tagged
    { get = get
    , set = set
    , update = update_
    }

{-                 Util                        -}

type IsUnused = IsUnused IsUnused

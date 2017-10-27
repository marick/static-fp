module Lens.Try3.Lens exposing (..)


import Tagged exposing (Tagged(..))

{- These are all crammed together in one module to avoid 
circular dependencies. 
-}


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
    update f = ifPresentUpdater get set (f >> Just)
  in
    Tagged
    { get = get
    , set = set
    , update = update
    }

      

{-                  Iffy Lenses               -}

type IffyTag = IffyTag IsUnused
type alias Iffy big small =
  Tagged IffyTag
    { get : big -> Maybe small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

iffy : (big -> Maybe small)
     -> (small -> big -> big)
     -> Iffy big small
iffy get set =
  Tagged
  { get = get
  , set = set
  , update = ifPresentUpdater get set
  }

addGuard : (small -> big -> big) -> (big -> Maybe small)
         -> (small -> big -> big)
addGuard set guardingGet small big = 
  case guardingGet big of
    Nothing ->
      big
    Just _ ->
      set small big


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

-- Note: In some cases, type `transformed` is `Maybe small`. But in others, it
-- is `small`. 
ifPresentUpdater : (big -> Maybe small)
                 -> (transformed -> big -> big)
                 -> (small -> transformed) -> big -> big
    
ifPresentUpdater get set f big =
  case get big of
    Nothing ->
      big
    Just small ->
      set (f small) big



type IsUnused = IsUnused IsUnused

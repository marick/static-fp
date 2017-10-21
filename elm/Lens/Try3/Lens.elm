module Lens.Try3.Lens exposing (..)


import Tagged exposing (Tagged(..))
import Dict exposing (Dict)
import Array exposing (Array)

{- These are all crammed together in one module to avoid 
circular dependencies. 
-}


{- By radically widening the types, we can have `get`, `set`, and
   `update` that work with different kinds of lenses.
-}
type alias GenericLens getter setter update =
  { get : getter 
  , set : setter
  , update : update
  }

get : Tagged tag (GenericLens getter s_ u_) -> getter
get (Tagged lens) =
  lens.get

set : Tagged tag (GenericLens g_ setter u_) -> setter
set (Tagged lens) =
  lens.set

update : Tagged tag (GenericLens g_ s_ updater) -> updater
update (Tagged lens) =
  lens.update


  
{-                  Classic Lenses             -}

type ClassicTag = ClassicTag IsUnused
type alias ClassicLens big small =
  Tagged ClassicTag
    { get : big -> small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

classic : (big -> small) -> (small -> big -> big) -> ClassicLens big small
classic get set =
  let 
    update f big =
      get big |> f |> flip set big
  in
    Tagged { get = get, set = set, update = update }
          

{-                  Upsert Lenses               -}

type UpsertTag = UpsertTag IsUnused
type alias UpsertLens big small =
  Tagged UpsertTag
    { get : big -> Maybe small
    , set : Maybe small -> big -> big
    , update : (small -> small) -> big -> big
    }

upsert : (big -> Maybe small)
      -> (small -> big -> big)
      -> (big -> big)          -- separate `delete` function
      -> UpsertLens big small
upsert get upsert remove =
  let
    set_ maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val

    update f big =
      case get big of
        Nothing ->
          big
        Just small ->
          set_ (Just <| f small) big
  in
    Tagged { get = get, set = set_, update = update }
          

      

{-                  Iffy Lenses               -}

type IffyTag = IffyTag IsUnused
type alias IffyLens big small =
  Tagged IffyTag
    { get : big -> Maybe small
    , set : small -> big -> big
    , update : (small -> small) -> big -> big
    }

iffy : (big -> Maybe small)
     -> (small -> big -> big)
     -> IffyLens big small
iffy get set =
  let
    update f big =
      case get big of
        Nothing ->
          big
        Just small ->
          set (f small) big
  in
    Tagged { get = get, set = set, update = update }
          

      

{-                 Util                        -}

      
type IsUnused = IsUnused IsUnused

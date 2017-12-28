module Lens.Try4.Exercises.UpsertUpdate exposing (..)


import Tagged exposing (Tagged(..))

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

{-               REMOVE THIS LINE
    
upsert : (big -> Maybe small)
      -> (small -> big -> big)
      -> (big -> big)          -- separate `delete` function
      -> Upsert big small
upsert get upserter remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upserter val
  in
    upsert2 get set

upsert2 : (big -> Maybe small)
        -> (Maybe small -> big -> big)
        -> Upsert big small
upsert2 get set =
  ...

                REMOVE THIS LINE TOO               -}
      

type IsUnused = IsUnused IsUnused

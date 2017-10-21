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

toIffy : ClassicLens big small -> IffyLens big small
toIffy (Tagged lens) = 
  iffy (lens.get >> Just) lens.set 

compose : ClassicLens a b -> ClassicLens b c -> ClassicLens a c
compose (Tagged a2b) (Tagged b2c) =
  classic
    (compose_get_with_certainty a2b.get b2c.get)
    (compose_set_with_certainty a2b.get b2c.set a2b.set)


composeUpsert : ClassicLens a b -> UpsertLens b c -> UpsertLens a c
composeUpsert (Tagged a2b) (Tagged b2c) =
  upsert2
    (compose_get_with_certainty a2b.get b2c.get)
    (compose_set_with_certainty a2b.get b2c.set a2b.set)

-- upsertComposeClassic : UpsertLens a b -> ClassicLens b c -> IffyLens a c
-- upsertComposeClassic (Tagged a2b) (Tagged b2c) =
--   iffy
--     (a2b.get >> b2c.get)
--     (compose_set_with_certainty a2b.get b2c.set a2b.set)
    
      
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
        -> UpsertLens big small
upsert2 get set =           
  let
    update f big =
      case get big of
        Nothing ->
          big
        Just small ->
          set (Just <| f small) big
  in
    Tagged { get = get, set = set, update = update }

           
      

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


compose_get_with_certainty : (a -> b) -> (b -> c) -> (a -> c)
compose_get_with_certainty getB getC =
  getB >> getC


compose_set_with_certainty : (a -> b) -> (c -> b -> b) -> (b -> a -> a) -> (c -> a -> a)
compose_set_with_certainty getB setB setA =
  \c a -> setA (getB a |> setB c) a


    


type IsUnused = IsUnused IsUnused

module Lens.Try3.Lens exposing (..)


import Tagged exposing (Tagged(..))

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
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

-- We can use the `compose` helpers here because an `UpsertLens` is just
-- a classic lens with the `part` type narrowed to `Maybe part`.
composeUpsert : ClassicLens a b -> UpsertLens b c -> UpsertLens a c
composeUpsert (Tagged a2b) (Tagged b2c) =
  upsert2
    (composeLensGet a2b.get b2c.get)
    (composeLensSet a2b.get b2c.set a2b.set)

      
      
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
    update f = ifPresentUpdater get set (f >> Just)
  in
    Tagged
    { get = get
    , set = set
    , update = update
    }

upsertToIffy : UpsertLens big small -> IffyLens big small
upsertToIffy (Tagged lens) =
  let
    set_ small =
      ifPresentSetter lens.get lens.set (Just small)
  in
    iffy lens.get set_
    
upsertComposeClassic : UpsertLens a b -> ClassicLens b c -> IffyLens a c
upsertComposeClassic a2b b2c =
  iffyComposeIffy
    (upsertToIffy a2b)
    (toIffy b2c)
    
      

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
  Tagged
  { get = get
  , set = set
  , update = ifPresentUpdater get set
  }


iffyComposeIffy (Tagged a2b) (Tagged b2c) =
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
    iffy get set


      
{-                 Util                        -}

ifPresentSetter : (big -> Maybe small)
                -> (Maybe small -> big -> big)
                -> (Maybe small -> big -> big)
ifPresentSetter get set =
  always >> ifPresentUpdater get set 


-- Note: In some cases, type `transformed` is `Maybe small`. But in some it
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

composeLensGet : (a -> b) -> (b -> c) -> (a -> c)
composeLensGet getB getC =
  getB >> getC

composeLensSet : (a -> b) -> (c -> b -> b) -> (b -> a -> a) -> (c -> a -> a)
composeLensSet getB setB setA =
  \c a -> setA (getB a |> setB c) a



type IsUnused = IsUnused IsUnused

module Lens.Try2.Types exposing (..)

{- These are all crammed together in one module because of the
circular dependencies. 
-}

type Lens big small =
  ClassicLens
  { get : big -> small
  , set : small -> big -> big
  }

type UpsertLens big small =
  UpsertLens
  { get : big -> Maybe small
  , set : Maybe small -> big -> big
  }
    
type WeakLens big small =
  WeakLens
  { get : big -> Maybe small
  , set : small -> big -> big
  }
    

---- 
  
lensMake : (big -> small) -> (small -> big -> big) -> Lens big small
lensMake get set =
  ClassicLens { get = get, set = set}

upsertMake : (big -> Maybe small) -> (Maybe small -> big -> big)
           -> UpsertLens big small
upsertMake get set =
  UpsertLens { get = get, set = set}

upsertMake3 : (big -> Maybe small)
            -> (small -> big -> big)
            -> (big -> big)           -- separate `delete` function
            -> UpsertLens big small
upsertMake3 get upsert remove =
  let
    set_ maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    upsertMake get set_

weakMake : (big -> Maybe small) -> (small -> big -> big) -> WeakLens big small
weakMake get set =
  let
    set_ small big =
      case get big of
        Nothing -> big
        Just _ -> set small big
  in
    WeakLens { get = get, set = set_}



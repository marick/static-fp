module Lens.Types exposing (..)

{- These are all crammed together in one module because of the
circular dependencies. 
-}

type Lens big small =
  Classic
  { get : big -> small
  , set : small -> big -> big
  }

type UpsertLens big small =
  Upsert
  { get : big -> Maybe small
  , set : Maybe small -> big -> big
  }
    
type WeakLens big small =
  Weak
  { get : big -> Maybe small
  , set : small -> big -> big
  }
    

---- 
  
lensMake : (big -> small) -> (small -> big -> big) -> Lens big small
lensMake get set =
  Classic { get = get, set = set}


upsertMake : (big -> Maybe small)
           -> (small -> big -> big)
           -> (big -> big)
           -> UpsertLens big small
upsertMake get upsert remove =
  let
    set_ maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    Upsert { get = get, set = set_}

weakMake : (big -> Maybe small) -> (small -> big -> big) -> WeakLens big small
weakMake get set =
  let
    set_ small big =
      case get big of
        Nothing -> big
        Just _ -> set small big
  in
    Weak { get = get, set = set_}



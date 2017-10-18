module Lens.Try1.Lens exposing
  ( .. )

import Dict exposing (Dict)

type alias Lens big small =
  { get : big -> small
  , set : small -> big -> big
  }


lens : (big -> small) -> (small -> big -> big) -> Lens big small
lens get set =
  { get = get, set = set}

get : Lens big small -> big -> small
get lens = lens.get
    
set : Lens big small -> small -> big -> big
set lens = lens.set

update : Lens big small -> (small -> small) -> big -> big
update lens f big =
  lens.get big
    |> f
    |> flip lens.set big


--- Applying lenses to `Dict`:

dict_1 : comparable -> Lens (Dict comparable val) (Maybe val)
dict_1 key =
  let
    get =
      Dict.get key

    set maybe = 
      case maybe of
        Nothing ->
          Dict.remove key
        Just val -> 
          Dict.insert key val
  in
    lens get set

upsertLens : (big -> Maybe small)
           -> (small -> big -> big)
           -> (big -> big)
           -> Lens big (Maybe small)
upsertLens get upsert remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    lens get set

dict_2 : comparable -> Lens (Dict comparable val) (Maybe val)
dict_2 key =
  upsertLens (Dict.get key) (Dict.insert key) (Dict.remove key)


--- Composite lenses
       
compose : Lens a b -> Lens b c -> Lens a c
compose a2b b2c =
  let 
    get =
      a2b.get >> b2c.get
        
    set c a =
      let
        b = a2b.get a
        newB = b2c.set c b
      in
        a2b.set newB a
  in
    lens get set

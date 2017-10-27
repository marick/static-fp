module Lens.Try1.Lens exposing
  ( .. )

import Dict exposing (Dict)

type alias Classic big small =
  { get : big -> small
  , set : small -> big -> big
  }


classic : (big -> small) -> (small -> big -> big) -> Classic big small
classic get set =
  { get = get, set = set}

get : Classic big small -> big -> small
get lens = lens.get
    
set : Classic big small -> small -> big -> big
set lens = lens.set

update : Classic big small -> (small -> small) -> big -> big
update lens f big =
  lens.get big
    |> f
    |> flip lens.set big


--- Applying lenses to `Dict`:

dict_1 : comparable -> Classic (Dict comparable val) (Maybe val)
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
    classic get set

upsertVariant : (big -> Maybe small)
              -> (small -> big -> big)
              -> (big -> big)
              -> Classic big (Maybe small)
upsertVariant get upsert remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    classic get set

dict_2 : comparable -> Classic (Dict comparable val) (Maybe val)
dict_2 key =
  upsertVariant (Dict.get key) (Dict.insert key) (Dict.remove key)


--- Composite lenses
       
compose : Classic a b -> Classic b c -> Classic a c
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
    classic get set

module Lens.Try2.UpsertLens exposing
  ( .. )

import Lens.Try2.Types as T exposing (WeakLens, Lens)
import Dict exposing (Dict)

type alias UpsertLens big small = T.UpsertLens big small

lens : (big -> Maybe small)
     -> (small -> big -> big)
     -> (big -> big)
     -> UpsertLens big small
lens = T.upsertMake

get : UpsertLens big small -> big -> Maybe small
get (T.Upsert lens) = lens.get
    
set : UpsertLens big small -> Maybe small -> big -> big
set (T.Upsert lens) = lens.set

update : UpsertLens big small -> (small -> small) -> big -> big
update (T.Upsert lens) f big =
  case lens.get big of
    Nothing ->
      big
    Just small ->
      lens.set (Just <| f small) big

--- Composite lenses


append : UpsertLens a b -> UpsertLens b c -> WeakLens a c
append (T.Upsert a2b) (T.Upsert b2c) =
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
          a2b.set (Just (b2c.set (Just c) b)) a
  in
    T.weakMake get set

andThen : UpsertLens b c -> UpsertLens a b -> WeakLens a c
andThen = flip append
      

appendLens : UpsertLens a b -> Lens b c -> WeakLens a c
appendLens (T.Upsert a2b) (T.Classic b2c) = 
  let
    get a =
      case a2b.get a of
        Nothing -> Nothing
        Just b -> Just (b2c.get b)
                  
    set c a =
      case a2b.get a of
        Nothing ->
          a
        Just b ->
          a2b.set (Just <| b2c.set c b) a
  in
    T.weakMake get set



--- Common lenses of this type

dict : comparable -> UpsertLens (Dict comparable val) val
dict key =
  lens (Dict.get key) (Dict.insert key) (Dict.remove key)


      

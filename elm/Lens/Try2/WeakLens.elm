module Lens.Try2.WeakLens exposing
  ( .. )

import Lens.Try2.Types as T exposing (Lens, UpsertLens)
import Array exposing (Array)

type alias WeakLens big small = T.WeakLens big small

lens : (big -> Maybe small) -> (small -> big -> big) -> WeakLens big small
lens = T.weakMake

get : WeakLens big small -> big -> Maybe small
get (T.WeakLens lens) = lens.get
    
set : WeakLens big small -> small -> big -> big
set (T.WeakLens lens) = lens.set

update : WeakLens big small -> (small -> small) -> big -> big
update (T.WeakLens lens) f big = 
  case lens.get big of
    Nothing ->
      big
    Just small ->
      lens.set (f small) big

--- Composite lenses

        
compose : WeakLens a b -> WeakLens b c -> WeakLens a c
compose (T.WeakLens a2b) (T.WeakLens b2c) =
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
    lens get set

--- Common lenses of this type

array : Int -> WeakLens (Array a) a
array i =
  lens (Array.get i) (Array.set i)


    
         

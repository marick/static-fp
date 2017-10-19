module Lens.Try2.UpsertLens exposing
  ( .. )

import Lens.Try2.Types as T exposing (Lens)
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)
import Lens.Try2.Lens as Lens
import Dict exposing (Dict)
import Maybe.Extra as Maybe

type alias UpsertLens big small = T.UpsertLens big small

lens : (big -> Maybe small)
     -> (small -> big -> big)
     -> (big -> big)
     -> UpsertLens big small
lens = T.upsertMake3

get : UpsertLens big small -> big -> Maybe small
get (T.UpsertLens lens) = lens.get
    
set : UpsertLens big small -> Maybe small -> big -> big
set (T.UpsertLens lens) = lens.set

-- Update is defined in exercise solutions, way at the end.

{-                      Conversions             -}

toWeakLens : UpsertLens big small -> WeakLens big small
toWeakLens (T.UpsertLens {get, set}) =
  let
    set_ small big =
      case get big of
        Nothing -> big
        Just _ -> set (Just small) big
  in
    T.weakMake get set_

{-                      Composite lenses        -}



compose : UpsertLens a b -> UpsertLens b c -> WeakLens a c
compose a2b b2c =
  WeakLens.compose (toWeakLens a2b) (toWeakLens b2c)

composeLens : UpsertLens a b -> Lens b c -> WeakLens a c
composeLens a2b b2c =
  WeakLens.compose (toWeakLens a2b) (Lens.toWeakLens b2c)


--- Common lenses of this type

dict : comparable -> UpsertLens (Dict comparable val) val
dict key =
  lens (Dict.get key) (Dict.insert key) (Dict.remove key)






{- 

           NO PEEKING!  EXERCISE SOLUTIONS BELOW!

-}























update : UpsertLens big small -> (small -> small) -> big -> big
update (T.UpsertLens lens) f big =
  case lens.get big of
    Nothing ->
      big
    just ->
      lens.set (Maybe.map f just) big


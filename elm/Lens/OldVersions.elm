module Lens.OldVersions exposing (..)

{- These are all crammed together in one module because of the
circular dependencies. Real use is via modules named after
specific types of lens 
-}

import Lens.Lens as Lens exposing (Lens)
import Dict exposing (Dict)


dictLens_1 : comparable -> Lens (Dict comparable val) (Maybe val)
dictLens_1 key =
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
    Lens.make get set

upsertLensMake_1 : (big -> Maybe small)
                 -> (small -> big -> big)
                 -> (big -> big)
                 -> Lens big (Maybe small)
upsertLensMake_1 get upsert remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    Lens.make get set
      
dictLens_2 : comparable -> Lens (Dict comparable val) (Maybe val)
dictLens_2 key =
  upsertLensMake_1 (Dict.get key) (Dict.insert key) (Dict.remove key)

module Choose.Common.Dict exposing
  ( ..
  )

import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Choose.Lens as Lens exposing (Lens)
import Dict exposing (Dict)

valueAt : comparable -> MaybeLens (Dict comparable val) val
valueAt key = 
  MaybeLens.make (Dict.get key) (Dict.insert key)


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
    Lens.make get set

dictLens2 : comparable -> Lens (Dict comparable val) (Maybe val)
dictLens2 key =
  upsertLens (Dict.get key) (Dict.insert key) (Dict.remove key)

-- This is the original version 
dictLens : comparable -> Lens (Dict comparable val) (Maybe val)
dictLens key =
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

-- composeLens : Lens (Dict comparable b) (Maybe b) -> Lens b c ->
--               Lens (Dict comparable b) (Maybe c)
-- composeLens a2b b2c =
--   let
--     get a =
--       case a2b.get a of
--         Just b -> Just (b2c.get b)
--         Nothing -> Nothing

--     set maybeC a = 
--       case maybeC of
--         Nothing -> a2b.set Nothing a
--         Just c ->
--           case a2b.get a of
--             Nothing -> a
--             Just b -> a2b.set (Just (b2c.set c b)) a
--   in
--     Lens.make get set



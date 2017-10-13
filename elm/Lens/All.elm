module Lens.All exposing (..)

{- These are all crammed together in one module because of the
circular dependencies. Real use is via modules named after
specific types of lens 
-}

import Dict exposing (Dict)

type alias LensGetter big small =          big -> small
type alias LensSetter big small = small -> big -> big

type alias Lens big small =
  { get : LensGetter big small
  , set : LensSetter big small
  }



---- Lens


  
lensMake : LensGetter big small -> LensSetter big small -> Lens big small
lensMake getter setter =
  { get = getter, set = setter}
  

lensGet : Lens big small -> LensGetter big small
lensGet chooser = chooser.get

lensSet : Lens big small -> LensSetter big small
lensSet chooser = chooser.set

lensUpdate : Lens big small -> (small -> small) -> big -> big
lensUpdate chooser f big =
  big
    |> chooser.get
    |> f
    |> flip chooser.set big
          
lensPlusLens : Lens a b -> Lens b c -> Lens a c
lensPlusLens a2b b2c =
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
    lensMake get set




         
upsertLensMake : (big -> Maybe small)
               -> (small -> big -> big)
               -> (big -> big)
               -> Lens big (Maybe small)
upsertLensMake get upsert remove =
  let
    set maybe = 
      case maybe of
        Nothing ->
          remove
        Just val -> 
          upsert val
  in
    lensMake get set

lensDict : comparable -> Lens (Dict comparable val) (Maybe val)
lensDict key =
  upsertLensMake (Dict.get key) (Dict.insert key) (Dict.remove key)


upsertPlusUpsert : Lens a (Maybe b) -> Lens b (Maybe c) -> Lens a (Maybe c)
upsertPlusUpsert a2b b2c =
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
          a2b.set (Just (b2c.set c b)) a
  in
    lensMake get set



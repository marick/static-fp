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
          
lensAndLens : Lens a b -> Lens b c -> Lens a c
lensAndLens a2b b2c =
  let 
    get =
      a2b.get >> b2c.get
        
    set c =
      lensUpdate a2b (b2c.set c)
      -- let
      --   b = a2b.get a
      -- in
      --   a |> a2b.set (b2c.set c b)

  in
    lensMake get set




         
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
    lensMake get set

dict : comparable -> Lens (Dict comparable val) (Maybe val)
dict key =
  upsertLens (Dict.get key) (Dict.insert key) (Dict.remove key)
         











    
      
lanimal = dict 55

animals = Dict.singleton 55 { tags = []}


          
lanimals = lensMake .animals (\part whole -> {whole | animals = part })
ltags = lensMake .tags (\part whole -> {whole | tags = part })
lanimal55 = dict 55

---- lmodel = lensAndLens lanimals (lensAndLens lanimal55 ltags)



model = { animals = Dict.singleton 55 { tags = []}}
      
          
lensAddUpsert : Lens a b -> Lens b (Maybe c) -> Lens a (Maybe c)
lensAddUpsert a2b b2c =
  let
    get = a2b.get >> b2c.get 

    set c a =
      let
        b = a2b.get a
        newB = b2c.set c b
      in
        a2b.set newB a
  in
    lensMake get set


lmodel = lensAddUpsert lanimals lanimal55

      
-- l2dict = lensAndLens (dict 33) (dict 44)

-- dict2 = Dict.singleton 33 (Dict.singleton 44 "foo")         
  

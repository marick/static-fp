module Lens.Try2.Lens exposing
  ( .. )

import Lens.Try2.Types as T exposing (UpsertLens)

type alias Lens big small = T.Lens big small

lens : (big -> small) -> (small -> big -> big) -> Lens big small
lens = T.lensMake

get : Lens big small -> big -> small
get (T.ClassicLens lens) = lens.get
    
set : Lens big small -> small -> big -> big
set (T.ClassicLens lens) = lens.set

update : Lens big small -> (small -> small) -> big -> big
update (T.ClassicLens lens) f big =
  lens.get big
    |> f
    |> flip lens.set big

--- Composite lenses

genericCompose : T.ObeysLensLaws a b -> T.ObeysLensLaws b c
               -> ( a -> c , c -> a -> a )
genericCompose a2b b2c = 
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
    (get, set)
       
compose : Lens a b -> Lens b c -> Lens a c
compose (T.ClassicLens a2b) (T.ClassicLens b2c) =
  genericCompose a2b b2c |> uncurry lens
       
composeUpsert : Lens a b -> UpsertLens b c -> UpsertLens a c
composeUpsert (T.ClassicLens a2b) (T.UpsertLens b2c) =
  genericCompose a2b b2c |> uncurry T.upsertMake


module Lens.Try2.Lens exposing
  ( .. )

import Lens.Try2.Types as T

type alias Lens big small = T.Lens big small

lens : (big -> small) -> (small -> big -> big) -> Lens big small
lens = T.lensMake

get : Lens big small -> big -> small
get (T.Classic lens) = lens.get
    
set : Lens big small -> small -> big -> big
set (T.Classic lens) = lens.set

update : Lens big small -> (small -> small) -> big -> big
update (T.Classic lens) f big =
  lens.get big
    |> f
    |> flip lens.set big

--- Composite lenses
       
append : Lens a b -> Lens b c -> Lens a c
append (T.Classic a2b) (T.Classic b2c) =
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
       
andThen : Lens b c -> Lens a b -> Lens a c
andThen = flip append


-- Used for testing
ops : Lens big small -> (big -> small, small -> big -> big)
ops (T.Classic lens) = (lens.get, lens.set)


                       

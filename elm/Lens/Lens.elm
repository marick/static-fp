module Lens.Lens exposing
  ( Lens
  , make
  , get, set, update

  , dict

  , and
  )

import Lens.All as A
import Dict exposing (Dict)

type alias Lens big small =
  { get : big -> small
  , set : small -> big -> big
  }

make : (big -> small) -> (small -> big -> big) -> Lens big small
make = A.lensMake

get : Lens big small -> big -> small
get = A.lensGet

set : Lens big small -> small -> big -> big
set = A.lensSet

update : Lens big small -> (small -> small) -> big -> big
update = A.lensUpdate


dict : comparable -> Lens (Dict comparable val) (Maybe val)
dict = A.dict         

{- Intended to be used in a pipeline -}
and : Lens b c -> Lens a b -> Lens a c
and = flip A.lensAndLens

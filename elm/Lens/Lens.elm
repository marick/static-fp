module Lens.Lens exposing
  ( Lens
  , make
  , get, set, update

  , dict

  , plus, upsertPlusUpsert
  )

import Lens.All as All
import Dict exposing (Dict)

type alias Lens big small =
  { get : big -> small
  , set : small -> big -> big
  }

make : (big -> small) -> (small -> big -> big) -> Lens big small
make = All.lensMake

get : Lens big small -> big -> small
get = All.lensGet

set : Lens big small -> small -> big -> big
set = All.lensSet

update : Lens big small -> (small -> small) -> big -> big
update = All.lensUpdate


dict : comparable -> Lens (Dict comparable val) (Maybe val)
dict = All.lensDict

{- Intended to be used in a pipeline -}
plus : Lens b c -> Lens a b -> Lens a c
plus = flip All.lensPlusLens

upsertPlusUpsert : Lens b (Maybe c) -> Lens a (Maybe b) -> Lens a (Maybe c)
upsertPlusUpsert = flip All.upsertPlusUpsert

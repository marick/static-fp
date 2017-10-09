module Choose.Common.Dict exposing
  ( valueAt
  )

import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Dict exposing (Dict)

valueAt : comparable -> MaybeLens (Dict comparable val) val
valueAt key = 
  MaybeLens.make (Dict.get key) (Dict.insert key)





type alias Getter big small =          big -> Maybe small
type alias Setter big small = small -> big -> big

set key new dict =
  Dict.singleton key new
monstrous = MaybeLens.make (Dict.get "key") (set "key")
    
    

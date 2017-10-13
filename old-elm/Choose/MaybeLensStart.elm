module Choose.MaybeLensStart exposing
  ( ..
  )

import Maybe.Extra as Maybe

type alias Getter big small =          big -> Maybe small
type alias Setter big small = small -> big -> big

type alias MaybeLens big small =
  { get : Getter big small
  , set : Setter big small
  }
type alias Optional big small = MaybeLens big small
  

make : Getter big small -> Setter big small -> MaybeLens big small
make getter setter =
  { get = getter, set = setter}
  

get : MaybeLens big small -> Getter big small
get chooser = chooser.get

set : MaybeLens big small -> Setter big small
set chooser = chooser.set

-- update : MaybeLens big small -> (small -> small) -> big -> big

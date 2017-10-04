module Choose.MaybePart exposing
  ( MaybePart, Optional
  , make
  , get, set, update, next
  )

import Maybe.Extra as Maybe

type alias Getter big small = big -> Maybe small
type alias Setter big small = small -> big -> big

type alias MaybePart big small =
  { get : Getter big small
  , set : Setter big small
  }
type alias Optional big small = MaybePart big small
  

make : Getter big small -> Setter big small -> MaybePart big small
make getter setter =
  { get = getter, set = setter}
  

get : MaybePart big small -> Getter big small
get chooser = chooser.get

set : MaybePart big small -> Setter big small
set chooser = chooser.set

update : MaybePart big small -> (small -> small) -> big -> big
update chooser f big =
  case chooser.get big of
    Nothing ->
      big
    Just small ->
      chooser.set (f small) big




-- Add the first chooser to the second. Intended to be pipelined       
next : MaybePart middle small -> MaybePart big middle -> MaybePart big small
next new previous =
  { get =
      \big -> previous.get big |> Maybe.unwrap Nothing new.get
  , set =
      \newSmall big -> 
        case previous.get big of
          Nothing ->
            big
          Just medium ->
            previous.set (new.set newSmall medium) big
  }


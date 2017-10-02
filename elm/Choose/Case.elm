module Choose.Case exposing (..)

type alias Getter big small = big -> Maybe small
type alias Setter big small = small -> big

type alias Case big small =
  { get : Getter big small
  , set : Setter big small
  }

make : Getter big small -> Setter big small -> Case big small
make getter setter =
  { get = getter, set = setter}
  
get : Case big small -> big -> Maybe small
get chooser = chooser.get

set : Case big small -> small -> big 
set chooser = chooser.set


update : Case big small -> (small -> small) -> big -> big
update chooser f big =
  case chooser.get big of
    Nothing ->
      big
    Just small ->
      chooser.set (f small)


next : Case middle small -> Case big middle -> Case big small
next new previous =
  { get =
      \ big -> 
        case previous.get big of
          Nothing -> Nothing
          Just val -> new.get val

  , set =
      \newSmall ->
        previous.set (new.set newSmall)
  }

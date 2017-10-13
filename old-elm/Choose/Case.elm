module Choose.Case exposing
  (..)

type alias Getter big small = big -> Maybe small
type alias Setter big small = small -> big

type alias Case big small =
  { get : Getter big small
  , set : Setter big small
  }
type alias Prism big small = Case big small

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


append : Case a b -> Case b c -> Case a c
append a2b b2c =
  { get =
      a2b.get >> Maybe.andThen b2c.get

  , set =
      b2c.set >> a2b.set
  }

-- Add the first chooser to the second. Intended to be pipelined       
next : Case b c -> Case a b -> Case a c
next = flip append

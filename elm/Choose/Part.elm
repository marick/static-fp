module Choose.Part exposing (..)

type alias Getter big small = big -> small
type alias Setter big small = small -> big -> big

type alias Part big small =
  { get : Getter big small
  , set : Setter big small
  }

make : Getter big small -> Setter big small -> Part big small
make getter setter =
  { get = getter, set = setter}
  

get : Part big small -> Getter big small
get chooser = chooser.get

set : Part big small -> Setter big small
set chooser = chooser.set

update : Part big small -> (small -> small) -> big -> big
update chooser f big =
  big
    |> chooser.get
    |> f
    |> flip chooser.set big

-- Add the first chooser to the second. Intended to be pipelined       
next : Part middle small -> Part big middle -> Part big small
next new previous =
  { get = previous.get >> new.get
  , set =
      \newSmall big ->
        let
          newMiddle = new.set newSmall (previous.get big)
        in
          previous.set newMiddle big
  }


module Choose.MaybeLens exposing
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

update : MaybeLens big small -> (small -> small) -> big -> big
update chooser f big =
  case chooser.get big of
    Nothing ->
      big
    Just small ->
      chooser.set (f small) big




append : MaybeLens a b -> MaybeLens b c -> MaybeLens a c
append a2b b2c =
  let 
    get =
      a2b.get >> Maybe.andThen b2c.get

    set c a =
      case a2b.get a of
          Nothing ->
            a
          Just b ->
            a |> a2b.set (b2c.set c b)

    {- Here's the excessively clever version               
    set c =
      update a2b (b2c.set c)
    -}
  in
    make get set

-- to be pipelined
next : MaybeLens b c -> MaybeLens a b -> MaybeLens a c
next = flip append  

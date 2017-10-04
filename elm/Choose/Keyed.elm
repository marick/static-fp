module Choose.Keyed exposing
  ( Keyed
  , make
  , get, set, update, next
  )

import Maybe.Extra as Maybe
import Choose.Part as Part

type alias Getter      big small =          big -> Maybe small
type alias WithDefault big small = small -> big -> small 
type alias Setter      big small = small -> big -> big

type alias Keyed big small =
  { get : Getter big small
  , set : Setter big small
  , withDefault : WithDefault big small
  , empty : big
  }

make : Getter big small -> Setter big small -> big -> Keyed big small
make getter setter empty =
  let
    withDefault default =
      getter >> Maybe.withDefault default
  in
    { get = getter
    , set = setter
    , withDefault = withDefault
    , empty = empty
    }
  

get : Keyed big small -> Getter big small
get chooser = chooser.get

set : Keyed big small -> Setter big small
set chooser = chooser.set

update : Keyed big small -> (small -> small) -> big -> big
update chooser f big =
  case chooser.get big of
    Nothing ->
      big
    Just small ->
      chooser.set (f small) big




-- Add the first chooser to the second. Intended to be pipelined

-- It's easier to write the code building from left to right


append : Keyed a b -> Keyed b c -> Keyed a c
append a2b b2c =
  let 
    get a =
      a |> a2b.get |> Maybe.andThen b2c.get
    set c a =
      let
        b =
          a2b.withDefault b2c.empty a
      in
        a2b.set (b2c.set c b) a
    empty =
      a2b.set b2c.empty a2b.empty
  in
    make get set empty

next = flip append


-- appendPart : Keyed a b -> Part b c -> Keyed a c
-- appendPart a2b b2c =
--   let 
--     get a =
--       a |> a2b.get |> Maybe.map b2c.get
--     set c a =
--       let
--         b = a2b.get a
--       in
--         a2b.set (b2c.set c b) a
--     empty =
--       a2b.set b2c.empty a2b.empty
--   in
--     make get set empty

       

module Optics.Lens exposing (..)

type alias Lens whole part =
  { get : whole -> part
  , set : part -> whole -> whole
  }

lens : (whole -> part) -> (part -> whole -> whole) -> Lens whole part
lens getter setter =
  { get = getter, set = setter}
  

get : Lens whole part -> whole -> part
get lens = lens.get

set : Lens whole part -> part -> whole -> whole 
set lens = lens.set

update : Lens whole part -> (part -> part) -> whole -> whole
update lens f whole =
  whole
    |> lens.get
    |> f
    |> flip lens.set whole

fromLenses : Lens whole middle -> Lens middle part -> Lens whole part
fromLenses outer inner =
  { get = outer.get >> inner.get
  , set =
      \newPart whole ->
        let
          newMiddle = inner.set newPart (outer.get whole)
        in
          outer.set newMiddle whole
  }
  
(..) outer inner =
  fromLenses outer inner

    

  

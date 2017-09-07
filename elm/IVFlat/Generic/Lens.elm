module IVFlat.Generic.Lens exposing
  ( Lens
  , lens
  , set
  , get
  , update
  ) 

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

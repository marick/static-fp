module Lens.Try2.SumLens exposing
  ( .. )

import Lens.Try2.Types as T exposing (Lens, UpsertLens)
import Array exposing (Array)
import Result

type alias SumLens big small = T.SumLens big small

lens : (big -> Maybe small) -> (small -> big) -> SumLens big small
lens = T.sumMake

get : SumLens big small -> big -> Maybe small
get (T.SumLens lens) = lens.get
    
set : SumLens big small -> small -> big
set (T.SumLens lens) = lens.set

update : SumLens big small -> (small -> small) -> big -> big
update (T.SumLens lens) f big = 
  case lens.get big of
    Nothing ->
      big
    Just small ->
      lens.set (f small) 

--- Composite lenses
        
compose : SumLens a b -> SumLens b c -> SumLens a c
compose (T.SumLens a2b) (T.SumLens b2c) =
  let
    get a =
      case a2b.get a of
        Nothing -> Nothing
        Just b -> b2c.get b
                  
    set c =
      c |> b2c.set |> a2b.set
  in
    lens get set

--- Common lenses of this type

ok : SumLens (Result err ok) ok
ok = lens Result.toMaybe Ok

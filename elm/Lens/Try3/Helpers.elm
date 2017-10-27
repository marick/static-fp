module Lens.Try3.Helpers exposing (..)


guardedUpdate : (big -> Maybe small)
              -> (transformed -> big -> big)
              -> (small -> transformed) -> big -> big
guardedUpdate guard set f big =
  case guard big of
    Nothing ->
      big
    Just small ->
      set (f small) big

-- This could be implemented in terms of `guardedUpdate`, but I think that's
-- unhelpful.
guardedSet : (big -> Maybe small)
           -> (small -> big -> big)
           -> (small -> big -> big)
guardedSet guard set small big = 
  case guard big of
    Nothing ->
      big
    Just _ ->
      set small big



    




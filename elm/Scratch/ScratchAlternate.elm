module Scratch.ScratchAlternate exposing (..)

type Maybelike a
  = Justlike a
  | Nothinglike

map : (arg -> result) -> Maybelike arg -> Maybelike result
map f maybe =
  case maybe of
    Nothinglike -> Nothinglike
    Justlike arg -> Justlike (f arg)

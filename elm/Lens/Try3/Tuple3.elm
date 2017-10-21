module Lens.Try3.Tuple3 exposing
  ( first
  , second
  , third
  )

import Lens.Try3.Lens as Lens exposing (ClassicLens)

first : ClassicLens (focus, a, b) focus
first =
  Lens.classic
    (\ (first, _, _) -> first)
    (\ first (_, second, third) -> (first, second, third))
      
second : ClassicLens (a, focus, b) focus
second =
  Lens.classic
    (\ (_, second, _) -> second)
    (\ second (first, _, third) -> (first, second, third))

third : ClassicLens (a, b, focus) focus
third =
  Lens.classic
    (\ (_, _, third) -> third)
    (\ third (first, second, _) -> (first, second, third))

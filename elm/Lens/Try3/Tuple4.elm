module Lens.Try3.Tuple4 exposing
  ( first
  , second
  , third
  , fourth
  )

import Lens.Try3.Lens as Lens exposing (ClassicLens)

first : ClassicLens (focus, a, b, c) focus
first =
  Lens.classic
    (\ (first, _, _, _) -> first)
    (\ first (_, second, third, fourth) -> (first, second, third, fourth))
      
second : ClassicLens (a, focus, b, c) focus
second =
  Lens.classic
    (\ (_, second, _, _) -> second)
    (\ second (first, _, third, fourth) -> (first, second, third, fourth))

third : ClassicLens (a, b, focus, c) focus
third =
  Lens.classic
    (\ (_, _, third, _) -> third)
    (\ third (first, second, _, fourth) -> (first, second, third, fourth))

fourth : ClassicLens (a, b, c, focus) focus
fourth =
  Lens.classic
    (\ (_, _, _, fourth) -> fourth)
    (\ fourth (first, second, third, _) -> (first, second, third, fourth))

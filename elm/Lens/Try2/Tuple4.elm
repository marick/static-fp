module Lens.Try2.Tuple4 exposing
  ( first
  , second
  , third
  , fourth
  )

import Lens.Try2.Lens as Lens exposing (Lens, lens)

first : Lens (focus, a, b, c) focus
first =
  lens
    (\ (first, _, _, _) -> first)
    (\ first (_, second, third, fourth) -> (first, second, third, fourth))
      
second : Lens (a, focus, b, c) focus
second =
  lens
    (\ (_, second, _, _) -> second)
    (\ second (first, _, third, fourth) -> (first, second, third, fourth))

third : Lens (a, b, focus, c) focus
third =
  lens
    (\ (_, _, third, _) -> third)
    (\ third (first, second, _, fourth) -> (first, second, third, fourth))

fourth : Lens (a, b, c, focus) focus
fourth =
  lens
    (\ (_, _, _, fourth) -> fourth)
    (\ fourth (first, second, third, _) -> (first, second, third, fourth))

module Lens.Tuple4 exposing
  ( first
  , second
  , third
  , fourth
  )

import Lens.Lens as Lens exposing (Lens)

first : Lens (focus, a, b, c) focus
first =
  Lens.make
    (\ (first, _, _, _) -> first)
    (\ first (_, second, third, fourth) -> (first, second, third, fourth))
      
second : Lens (a, focus, b, c) focus
second =
  Lens.make
    (\ (_, second, _, _) -> second)
    (\ second (first, _, third, fourth) -> (first, second, third, fourth))

third : Lens (a, b, focus, c) focus
third =
  Lens.make
    (\ (_, _, third, _) -> third)
    (\ third (first, second, _, fourth) -> (first, second, third, fourth))

fourth : Lens (a, b, c, focus) focus
fourth =
  Lens.make
    (\ (_, _, _, fourth) -> fourth)
    (\ fourth (first, second, third, _) -> (first, second, third, fourth))
         

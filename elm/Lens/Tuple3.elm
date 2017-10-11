module Lens.Tuple3 exposing
  ( first
  , second
  , third
  )

import Choose.Lens as Lens exposing (Lens)

first : Lens (focus, a, b) focus
first =
  Lens.make
    (\ (first, _, _) -> first)
    (\ first (_, second, third) -> (first, second, third))
      
second : Lens (a, focus, b) focus
second =
  Lens.make
    (\ (_, second, _) -> second)
    (\ second (first, _, third) -> (first, second, third))

third : Lens (a, b, focus) focus
third =
  Lens.make
    (\ (_, _, third) -> third)
    (\ third (first, second, _) -> (first, second, third))

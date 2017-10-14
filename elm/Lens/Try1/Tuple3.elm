module Lens.Try1.Tuple3 exposing
  ( first
  , second
  , third
  )

import Lens.Try1.Lens as Lens exposing (Lens, lens)

first : Lens (focus, a, b) focus
first =
  lens
    (\ (first, _, _) -> first)
    (\ first (_, second, third) -> (first, second, third))
      
second : Lens (a, focus, b) focus
second =
  lens
    (\ (_, second, _) -> second)
    (\ second (first, _, third) -> (first, second, third))

third : Lens (a, b, focus) focus
third =
  lens
    (\ (_, _, third) -> third)
    (\ third (first, second, _) -> (first, second, third))

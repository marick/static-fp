module Lens.Try4.Tuple3 exposing
  ( first
  , second
  , third
  )

import Lens.Try4.Lens as Lens

first : Lens.Classic (focus, a, b) focus
first =
  Lens.classic
    (\ (first, _, _) -> first)
    (\ first (_, second, third) -> (first, second, third))
      
second : Lens.Classic (a, focus, b) focus
second =
  Lens.classic
    (\ (_, second, _) -> second)
    (\ second (first, _, third) -> (first, second, third))

third : Lens.Classic (a, b, focus) focus
third =
  Lens.classic
    (\ (_, _, third) -> third)
    (\ third (first, second, _) -> (first, second, third))

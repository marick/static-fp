module Choose.Common.Tuple3 exposing
  ( first
  , second
  , third
  )

import Choose.Part as Part exposing (Part)

first : Part (focus, a, b) focus
first =
  Part.make
    (\ (first, _, _) -> first)
    (\ first (_, second, third) -> (first, second, third))
      
second : Part (a, focus, b) focus
second =
  Part.make
    (\ (_, second, _) -> second)
    (\ second (first, _, third) -> (first, second, third))

third : Part (a, b, focus) focus
third =
  Part.make
    (\ (_, _, third) -> third)
    (\ third (first, second, _) -> (first, second, third))

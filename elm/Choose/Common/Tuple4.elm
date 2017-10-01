module Choose.Common.Tuple4 exposing
  ( first
  , second
  , third
  , fourth
  )

import Choose.Part as Part exposing (Part)

first : Part (focus, a, b, c) focus
first =
  Part.make
    (\ (first, _, _, _) -> first)
    (\ first (_, second, third, fourth) -> (first, second, third, fourth))
      
second : Part (a, focus, b, c) focus
second =
  Part.make
    (\ (_, second, _, _) -> second)
    (\ second (first, _, third, fourth) -> (first, second, third, fourth))

third : Part (a, b, focus, c) focus
third =
  Part.make
    (\ (_, _, third, _) -> third)
    (\ third (first, second, _, fourth) -> (first, second, third, fourth))

fourth : Part (a, b, c, focus) focus
fourth =
  Part.make
    (\ (_, _, _, fourth) -> fourth)
    (\ fourth (first, second, third, _) -> (first, second, third, fourth))
         

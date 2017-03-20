module SumTypes.Percent exposing (..)

type Percent = Percent Float

increase : Percent -> Float -> Float
increase (Percent percent) float =
  float * (1.0 + percent) 

decrease : Percent -> Float -> Float
decrease (Percent percent) float =
  float * (1.0 - percent) 

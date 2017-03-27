module SumTypes.Grouping exposing (..)

type Point = 
  Point Float Float

distanceFromOrigin : Point -> Float
distanceFromOrigin (Point x y) =
  sqrt (x * x + y * y)



summarizeTuple : (String, Bool) -> String
summarizeTuple (property, value) =
  property ++ "? " ++ toString value

    
type Property = Property String Bool
    
summarize: Property -> String
summarize (Property key value) =
  key ++ "? " ++ toString value
    

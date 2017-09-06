module SumTypes.PropertyValueSolution exposing (..)

import Date exposing (Date)

type PropertyValue
  = Int Int
  | Bool Bool
  | Date Date

-- Exercise 1
    
valueInt : PropertyValue -> Maybe Int
valueInt value = 
  case value of
    Int int -> Just int
    _ -> Nothing

-- Exercise 2
         
isValueInt : PropertyValue -> Bool
isValueInt value = 
  valueInt value
    |> Maybe.map (always True)
    |> Maybe.withDefault False

-- Exercise 3

unwrap : result -> (a -> result) -> Maybe a -> result
unwrap default transformer maybe =
  maybe
    |> Maybe.map transformer
    |> Maybe.withDefault default
       
isValueInt2 : PropertyValue -> Bool
isValueInt2 value = 
  valueInt value |> unwrap False (always True)

-- Exercise 4
    
isJust : Maybe a -> Bool
isJust maybe = 
  maybe |> unwrap False (always True)
    
isValueInt3 : PropertyValue -> Bool
isValueInt3 value = 
  isJust (valueInt value)

-- Exercise 5

isValueInt4 : PropertyValue -> Bool
isValueInt4 =
  valueInt >> isJust

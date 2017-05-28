module Dict.PropertySolution exposing (..)

import Dict exposing (Dict)
import Date exposing (Date)
import Date.Extra as Date

import Dict.PropertyValue as Value exposing (PropertyValue(..))

-- Exercise 1

type alias Key = String
type alias Properties = Dict Key PropertyValue

properties : Properties
properties =
  Dict.fromList [
      ("int1", Value.Int 1)
    , ("int2", Value.Int 2)
    , ("date", Value.Date <| Date.fromCalendarDate 2017 Date.May 26)
    , ("false", Value.Bool False)
    , ("true", Value.Bool True)
    ]

-- Exercise 2

getIntValue2 : Key -> Properties -> Maybe Int
getIntValue2 key properties =
  Dict.get key properties |> Maybe.andThen Value.valueInt

-- Exercise 3 

getIntValue3 : Key -> Properties -> Maybe Int
getIntValue3 key =
  Dict.get key >> Maybe.andThen Value.valueInt

-- Exercise 4

toIntMaybe : Properties -> Dict Key (Maybe Int)
toIntMaybe properties =
  let
    converter _ value =
      Value.valueInt value
  in
    Dict.map converter properties

-- Exercise 5
    
isValueInt4 : PropertyValue -> Bool
isValueInt4 = valueInt >> isJust

-- Exercise 5

onlyInts : Properties -> Properties
onlyInts dict = 
  let 
    filterFn _ value = 
      Value.isValueInt value 
  in
    Dict.filter filterFn dict

-- Exercise 6

toInts : Properties -> Dict Key Int
toInts dict =
  let 
    unwrapper _ value =
      case value of 
        Int i -> i
        -- in context, all the other possibilities are impossible,
        -- but I still have to cover them.
        _ -> -999999
  in
    dict |> onlyInts |> Dict.map unwrapper

toIntsFold : Properties -> Dict Key Int
toIntsFold dict =
  let
    handlePair key value accumulator =
      case value of
        Int i ->   -- Add new key/value pair to accumulator
          Dict.insert key i accumulator
        _ ->       -- Discard pair
          accumulator
  in
    Dict.foldl handlePair Dict.empty dict

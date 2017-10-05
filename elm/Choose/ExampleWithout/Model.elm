module Choose.ExampleWithout.Model exposing (..)

import Choose.ExampleWithout.Animal as Animal exposing (Animal)
import Dict exposing (Dict)

type alias AnimalDict = Dict Animal.Id Animal

type alias Model =
  { animals : AnimalDict
  }
  

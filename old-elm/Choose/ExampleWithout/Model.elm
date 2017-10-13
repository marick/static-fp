module Choose.ExampleWithout.Model exposing (..)

import Choose.ExampleWithout.Animal as Animal exposing (Animal)
import Dict exposing (Dict)

type alias Model =
  { animals : Dict Animal.Id Animal
  }
  

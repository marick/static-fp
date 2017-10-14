module Lens.Motivation.WithoutLenses.Model exposing (..)

import Lens.Motivation.WithoutLenses.Animal as Animal exposing (Animal)
import Dict exposing (Dict)

type alias Model =
  { animals : Dict Animal.Id Animal
  }
  

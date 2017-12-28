module Lens.Motivation.WithLenses.Model exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Motivation.WithLenses.TagDb as TagDb exposing (TagDb)
import Lens.Try4.Lens as Lens 
import Lens.Try4.Compose as Compose
import Lens.Try4.Dict as Dict
import Dict exposing (Dict)


type alias Model =
  { animals : Dict Animal.Id Animal
  }

animals : Lens.Classic Model (Dict Animal.Id Animal) 
animals =
  Lens.classic .animals (\animals model -> { model | animals = animals })

oneAnimal : Animal.Id -> Lens.Upsert Model Animal
oneAnimal id =
  Compose.classicAndUpsert animals (Dict.lens id)

updateAnimal : Animal.Id -> (Animal -> Animal) -> Model -> Model
updateAnimal id =
  Lens.update (oneAnimal id)
  
addAnimalTag : Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  updateAnimal id (Animal.addTag tag)

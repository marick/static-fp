module Lens.Motivation.WithLenses.Model exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Try3.Lens as Lens 
import Lens.Try3.Compose as Compose
import Dict exposing (Dict)
import Lens.Try3.Dict as Dict
import Array


type alias Model =
  { animals : Dict Animal.Id Animal
  }

animals : Lens.Classic Model (Dict Animal.Id Animal) 
animals =
  Lens.classic .animals (\animals model -> { model | animals = animals })

animal : Animal.Id -> Lens.Upsert Model Animal
animal id =
  Compose.classicAndUpsert animals (Dict.lens id)

updateAnimal : Animal.Id -> (Animal -> Animal) -> Model -> Model
updateAnimal id =
  Lens.update (animal id)


-- An alternate example    
    
animalTags : Animal.Id -> Lens.Humble Model Animal.Tags
animalTags id =
  Compose.upsertAndClassic (animal id) Animal.tags
  
addAnimalTag : Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  updateAnimal id (Animal.addTag tag)

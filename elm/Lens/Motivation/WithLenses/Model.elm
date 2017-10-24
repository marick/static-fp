module Lens.Motivation.WithLenses.Model exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Try3.Lens as Lens exposing (ClassicLens, UpsertLens, IffyLens)
import Lens.Try3.Compose.Operators exposing (..)
import Dict exposing (Dict)
import Lens.Try3.Dict as Dict


type alias Model =
  { animals : Dict Animal.Id Animal
  }

animals : ClassicLens Model (Dict Animal.Id Animal) 
animals =
  Lens.classic .animals (\animals model -> { model | animals = animals })

animal : Animal.Id -> UpsertLens Model Animal
animal id =
  animals ...^ Dict.lens id

animalTags : Animal.Id -> IffyLens Model Animal.Tags
animalTags id =
  animal id ^... Animal.tags
    
updateAnimal : Animal.Id -> (Animal -> Animal) -> Model -> Model
updateAnimal id =
  Lens.update (animal id)
  

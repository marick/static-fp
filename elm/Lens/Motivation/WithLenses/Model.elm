module Lens.Motivation.WithLenses.Model exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Try2.Lens as Lens exposing (Lens)
import Lens.Try2.UpsertLens as UpsertLens exposing (UpsertLens)
import Lens.Try2.WeakLens as WeakLens exposing (WeakLens)
import Dict exposing (Dict)


type alias Model =
  { animals : Dict Animal.Id Animal
  }

animals : Lens Model (Dict Animal.Id Animal) 
animals =
  Lens.lens .animals (\animals model -> { model | animals = animals })


animal : Animal.Id -> UpsertLens Model Animal
animal id =
  Lens.composeUpsert animals (UpsertLens.dict id)

animalTags : Animal.Id -> WeakLens Model Animal.Tags
animalTags id =
  UpsertLens.composeLens (animal id) Animal.tags
    
updateAnimal : Animal.Id -> (Animal -> Animal) -> Model -> Model
updateAnimal id =
  UpsertLens.update (animal id)
  

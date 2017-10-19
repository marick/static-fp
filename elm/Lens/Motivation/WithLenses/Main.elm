module Lens.Motivation.WithLenses.Main exposing (..)

import Dict
import Array
import Lens.Motivation.WithLenses.Model as Model exposing (Model)
import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Try2.WeakLens as WeakLens
import Lens.Try2.UpsertLens as UpsertLens

type Msg 
  = AddTag Animal.Id String
  | AddTag2 Animal.Id String
  | AddTag3 Animal.Id String

startingId : Animal.Id    
startingId = 3838

startingAnimal : Animal
startingAnimal =
  { tags = Array.fromList ["mare"]
  , id = startingId
  }
  
init : Model
init =
  { animals = 
      Dict.singleton startingId startingAnimal
  }

update : Msg -> Model -> Model
update msg model = 
  case msg of
    AddTag animalId tag ->
      UpsertLens.update
        (Model.animal animalId)
        (Animal.addTagToAnimal tag)
        model

    AddTag2 animalId tag ->
      Model.updateAnimal
        animalId
        (Animal.addTagToAnimal tag)
        model

    AddTag3 animalId tag ->
      WeakLens.update
        (Model.animalTags animalId)
        (Animal.addTagToTags tag)
        model

        

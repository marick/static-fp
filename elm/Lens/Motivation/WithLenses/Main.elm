module Lens.Motivation.WithLenses.Main exposing (..)

import Dict
import Array
import Lens.Motivation.WithLenses.Model as Model exposing (Model)
import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Try3.Lens as Lens

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
      Lens.update (Model.animal animalId) (Animal.addTag tag) model

    AddTag2 animalId tag ->
      Model.updateAnimal        animalId  (Animal.addTag tag) model

    AddTag3 animalId tag ->
      Model.addAnimalTag        animalId                 tag  model
          

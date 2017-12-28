module Lens.Motivation.WithLenses.Main exposing (..)

import Lens.Motivation.WithLenses.Model as Model exposing (Model)
import Lens.Motivation.WithLenses.Animal as Animal exposing (Animal)
import Lens.Motivation.WithLenses.TagDb as TagDb exposing (TagDb)
import Lens.Try4.Lens as Lens
import Dict
import Array

type Msg 
  = AddTag Animal.Id String
  | AddTag2 Animal.Id String
  | AddTag3 Animal.Id String


{- 
   `init` is here for convenience when working in the repl:

   > import Lens.Motivation.WithLenses.Main exposing (..)
   > update (AddTag 3838 "skittish") init

   In real life, it would probably be in the `Model` module.
-}

init : Model
init =
  { animals = 
      Dict.singleton startingAnimal.id startingAnimal
  }

startingAnimal : Animal
startingAnimal =
  Animal.named "Genesis" 3838 |> Animal.addTag "mare"

---
  
update : Msg -> Model -> Model
update msg model = 
  case msg of
    AddTag animalId tag ->
      Lens.update (Model.oneAnimal animalId) (Animal.addTag tag) model

    AddTag2 animalId tag ->
      Model.updateAnimal           animalId  (Animal.addTag tag) model

    AddTag3 animalId tag ->
      Model.addAnimalTag           animalId                 tag  model
          

module Lens.Motivation.Restructured.Main exposing (..)

import Lens.Motivation.Restructured.Model as Model exposing (Model)
import Lens.Motivation.Restructured.Animal as Animal exposing (Animal)
import Lens.Motivation.Restructured.TagDb as TagDb exposing (TagDb)
import Lens.Try3.Lens as Lens
import Dict
import Array

type Msg 
  = AddTag3 Animal.Id String


{- 
   `init` is here for convenience when working in the repl:

   > import Lens.Motivation.Restructured.Main exposing (..)
   > update (AddTag3 3838 "skittish") init

   In real life, it would probably be in the `Model` module.
-}

init : Model
init =
  { animals = 
      Dict.singleton startingAnimal.id startingAnimal
  , tagDb =
      TagDb.empty |> TagDb.addAnimal startingAnimal.id ["mare"]
  }
  
startingAnimal : Animal
startingAnimal =
  { id = 3838
  , name = "Genesis"
  }

---
  
update : Msg -> Model -> Model
update msg model = 
  case msg of
    AddTag3 animalId tag ->
      Model.addAnimalTag           animalId                 tag  model
          

module Lens.Motivation.WithoutLenses.Main exposing (..)

import Dict
import Array
import Lens.Motivation.WithoutLenses.Model as Model exposing (Model)
import Lens.Motivation.WithoutLenses.Animal as Animal exposing (Animal)

type Msg =
  AddTag Animal.Id String

{- 
   `init` is here for convenience when working in the repl:

   > import Lens.Motivation.WithoutLenses.Main exposing (..)
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
  { id = 3838
  , name = "Genesis"
  , tags = Array.fromList ["mare"]
  }

---
  
update : Msg -> Model -> Model
update msg model = 
  case msg of
    AddTag animalId tag ->
      addTag animalId tag model

addTag : Animal.Id -> String -> Model -> Model        
addTag id tag model = 
  case Dict.get id model.animals of
    Nothing ->
      model
    Just animal ->
      { model |
          animals = Dict.insert id (Animal.addTag tag animal) model.animals
      }

addTag2 : Animal.Id -> String -> Model -> Model        
addTag2 id tag model =
  let
    adder = Animal.addTag tag |> Maybe.map
  in
    { model |
        animals = Dict.update id adder model.animals
    }
      

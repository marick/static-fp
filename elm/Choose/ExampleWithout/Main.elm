module Choose.ExampleWithout.Main exposing (..)

import Dict
import Array
import Choose.ExampleWithout.Model as Model exposing (Model)
import Choose.ExampleWithout.Animal as Animal exposing (Animal)

type Msg =
  AddTag Animal.Id String

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
    adder = Animal.addTag tag
  in
    { model |
        animals = 
          Dict.update id (Maybe.map adder) model.animals
    }
      

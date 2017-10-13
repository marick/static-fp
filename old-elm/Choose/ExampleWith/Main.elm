module Choose.ExampleWith.Main exposing (..)

import Dict
import Array
import Choose.ExampleWith.Model as Model exposing (Model)
import Choose.ExampleWith.Animal as Animal exposing (Animal)
import Choose.MaybeLens as MaybeLens

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
addTag id tag  = 
  MaybeLens.update
    (Model.animalTags id)
    (Animal.addTag tag)


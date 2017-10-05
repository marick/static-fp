module Choose.ExampleWith.Main exposing (..)

import Dict
import Array
import Choose.Part as Part
import Choose.ExampleWith.Model as Model exposing (Model)
import Choose.ExampleWith.Animal as Animal exposing (Animal)
import Choose.MaybePart as MaybePart

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
      addTagToEnd animalId tag model


addTagToEnd : Animal.Id -> String -> Model -> Model        
addTagToEnd id tag = 
  MaybePart.update (Model.animalTags id) (Array.push tag)


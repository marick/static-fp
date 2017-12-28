module Lens.Motivation.Restructured.Model exposing (..)

import Lens.Motivation.Restructured.Animal as Animal exposing (Animal)
import Lens.Motivation.Restructured.TagDb as TagDb exposing (TagDb)
import Lens.Try4.Lens as Lens 
import Lens.Try4.Compose as Compose
import Lens.Try4.Dict as Dict
import Dict exposing (Dict)


type alias Model =
  { animals : Dict Animal.Id Animal
  , tagDb : TagDb
  }

animals : Lens.Classic Model (Dict Animal.Id Animal) 
animals =
  Lens.classic .animals (\animals model -> { model | animals = animals })

tagDb : Lens.Classic Model TagDb
tagDb =
  Lens.classic .tagDb (\tagDb model -> { model | tagDb = tagDb })

oneAnimal : Animal.Id -> Lens.Upsert Model Animal
oneAnimal id =
  Compose.classicAndUpsert animals (Dict.lens id)

addAnimalTag : Animal.Id -> String -> Model -> Model
addAnimalTag id tag =
  Lens.update tagDb (TagDb.addTag id tag) 

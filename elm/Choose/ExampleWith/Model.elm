module Choose.ExampleWith.Model exposing (..)

import Choose.ExampleWith.Animal as Animal exposing (Animal)

import Dict exposing (Dict)
import Choose.Common.Dict as Dict
import Choose.Part as Part exposing (Part)
import Choose.Combine.Part as Part
import Choose.MaybePart as MaybePart exposing (MaybePart)
import Choose.Combine.MaybePart as MaybePart

type alias AnimalDict = Dict Animal.Id Animal

type alias Model =
  { animals : AnimalDict
  }
  
animals : Part Model AnimalDict
animals = Part.make .animals (\animals model -> { model | animals = animals })

animalAt : Animal.Id -> MaybePart Model Animal
animalAt id =
  animals
    |> Part.nextMaybePart (Dict.valueAt id)

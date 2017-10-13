module Choose.ExampleWith.Model exposing (..)

import Choose.ExampleWith.Animal as Animal exposing (Animal)

import Array exposing (Array)
import Dict exposing (Dict)
import Choose.Common.Dict as Dict
import Choose.Lens as Lens exposing (Lens)
import Choose.Combine.Lens as Lens
import Choose.MaybeLens as MaybeLens exposing (MaybeLens)
import Choose.Combine.MaybeLens as MaybeLens

type alias AnimalDict = Dict Animal.Id Animal

type alias Model =
  { animals : AnimalDict
  }
  
animals : Lens Model AnimalDict
animals = Lens.make .animals (\animals model -> { model | animals = animals })

animalAt : Animal.Id -> MaybeLens Model Animal
animalAt id =
  animals
    |> Lens.nextMaybeLens (Dict.valueAt id)

animalTags : Animal.Id -> MaybeLens Model (Array String)
animalTags id =
  animalAt id
    |> MaybeLens.nextLens Animal.tags

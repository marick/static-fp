module Lens.Motivation.WithLenses.TestAccess.Tags exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal
import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Lens.Try3.Dict as Dict
import Dict exposing (Dict)
import Dict exposing (Dict)
import Array exposing (Array)

type alias IdToTags = Dict Animal.Id (Array String)
type alias TagToIds = Dict String (Array Animal.Id)

type alias Main =
  { allTags : IdToTags
  , allIds : TagToIds
  }


-- Lenses

allTags : Lens.Classic Main IdToTags
allTags =
  Lens.classic .allTags (\dict whole -> { whole | allTags = dict })

allIds : Lens.Classic Main TagToIds
allIds =
  Lens.classic .allIds (\dict whole -> { whole | allIds = dict })


idTags : Animal.Id -> Lens.Humble Main (Array String)
idTags id =
  Compose.classicAndHumble allTags (Dict.humbleLens id)

idTags_upsert : Animal.Id -> Lens.Upsert Main (Array String)
idTags_upsert id =
  Compose.classicAndUpsert allTags (Dict.lens id)

tagIds : String -> Lens.Humble Main (Array Animal.Id)
tagIds tag =
  Compose.classicAndHumble allIds (Dict.humbleLens tag)

tagIds_upsert : String -> Lens.Upsert Main (Array Animal.Id)
tagIds_upsert tag =
  Compose.classicAndUpsert allIds (Dict.lens tag)

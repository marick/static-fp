module Lens.Motivation.Restructured.TestAccess.TagDb exposing (..)

import Lens.Motivation.Restructured.Animal as Animal
import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Lens.Try3.Dict as Dict
import Dict exposing (Dict)
import Dict exposing (Dict)
import Array exposing (Array)

type alias IdToTags = Dict Animal.Id (Array String)
type alias TagToIds = Dict String (Array Animal.Id)

type alias TagDb =
  { allTags : IdToTags
  , allIds : TagToIds
  }


-- Lenses

allTags : Lens.Classic TagDb IdToTags
allTags =
  Lens.classic .allTags (\dict whole -> { whole | allTags = dict })

allIds : Lens.Classic TagDb TagToIds
allIds =
  Lens.classic .allIds (\dict whole -> { whole | allIds = dict })


idTags : Animal.Id -> Lens.Humble TagDb (Array String)
idTags id =
  Compose.classicAndHumble allTags (Dict.humbleLens id)

idTags_upsert : Animal.Id -> Lens.Upsert TagDb (Array String)
idTags_upsert id =
  Compose.classicAndUpsert allTags (Dict.lens id)

tagIds : String -> Lens.Humble TagDb (Array Animal.Id)
tagIds tag =
  Compose.classicAndHumble allIds (Dict.humbleLens tag)

tagIds_upsert : String -> Lens.Upsert TagDb (Array Animal.Id)
tagIds_upsert tag =
  Compose.classicAndUpsert allIds (Dict.lens tag)

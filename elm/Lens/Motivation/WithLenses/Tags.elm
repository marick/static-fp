module Lens.Motivation.WithLenses.Tags exposing
  ( Main
  , empty
  , tags
  , ids
  , addAnimal
  , addTag
  )

import Lens.Motivation.WithLenses.TestAccess.Tags as Support exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal
import Lens.Try3.Lens as Lens
import Dict exposing (Dict)
import Array exposing (Array)


type alias Main = Support.Main

empty : Main  
empty =
  { allTags = Dict.empty
  , allIds = Dict.empty
  }

tags : Animal.Id -> Main -> Maybe (Array String)
tags = idTags >> Lens.get

ids : String -> Main -> Maybe (Array Animal.Id)
ids = tagIds >> Lens.get
    
addAnimal : Animal.Id -> List String -> Main -> Main
addAnimal id tags main =
  let
    withId =
      Lens.set (idTags_upsert id) (Just Array.empty) main
  in
    List.foldl (addTag id) withId tags
  

addTag : Animal.Id -> String -> Main -> Main
addTag id tag main = 
    main
      |> updateIdTags id (Array.push tag)
      |> updateTagIds tag (Array.push id)


--- Helpers

type alias StringsMapper = Array String -> Array String
type alias IdsMapper = Array Animal.Id -> Array Animal.Id

updateIdTags : Animal.Id -> StringsMapper -> Main -> Main
updateIdTags id = 
  Lens.update (idTags id)

updateTagIds: String -> IdsMapper -> Main -> Main
updateTagIds tag =
  Lens.updateWithDefault (tagIds_upsert tag) Array.empty

    
         

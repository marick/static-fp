module Lens.Motivation.WithLenses.TagDbTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (..)
import Lens.Final.Lens as Lens
import Dict
import Array

import Lens.Motivation.WithLenses.TagDb as Db
import Lens.Motivation.WithLenses.TestAccess.TagDb as Db

tags = Lens.get << Db.idTags
ids = Lens.get << Db.tagIds

empty : Test
empty =
    describe "empty"
      [ is (.allTags Db.empty)   Dict.isEmpty  "start with no tags"
      , is (.allIds  Db.empty)   Dict.isEmpty  "start with no ids"

      , equal (tags 5 Db.empty)       Nothing    "no id to fetch"
      , equal (ids "jersey" Db.empty) Nothing    "no tag to fetch"
      ]

addingAnAnimal : Test
addingAnAnimal =
  let
    added = Db.empty |> Db.addAnimal 5 ["jersey", "fractious"] 
    a = Array.fromList >> Just
  in
    concat
    [ describe "adding an animal"
        [ equal_ (tags 5 added)             (a ["jersey", "fractious"])
        , equal_ (ids "jersey" added)       (a [5])
        , equal  (ids "fractious" added)    (a [5]) "both tags have 5"
        ]
    , describe "adding a second animal" <|
        let
          second = added |> Db.addAnimal 88 ["jersey", "down"]
        in
          [ equal_ (tags 88 second)        (a ["jersey", "down"])
          , equal_ (ids "jersey" second)   (a [5, 88])
          , equal_ (ids "down" second)     (a [88])
          ]
    ]
          


addingTag : Test
addingTag =
  let
    original = Db.empty |> Db.addAnimal 5 ["jersey", "fractious"]
          
    a = Array.fromList >> Just
  in
    concat
      [ describe "tags are added at the end" <|
          let
            new = original |> Db.addTag 5 "down"
          in
            [ equal_ (tags 5 new)       (a ["jersey", "fractious", "down"])
            , equal_ (ids "down" new)   (a [5])
            ]
      , describe "multiple tags are allowed" <|
          let
            new = original |> Db.addTag 5 "jersey"
          in
            [ equal_ (tags 5 new)       (a ["jersey", "fractious", "jersey"])
            ]
      ]

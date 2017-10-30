module Lens.Motivation.WithLenses.TagDbTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Dict
import Array

import Lens.Motivation.WithLenses.TagDb as Db

empty : Test
empty =
    describe "empty"
      [ is (.allTags Db.empty)   Dict.isEmpty  "start with no tags"
      , is (.allIds  Db.empty)   Dict.isEmpty  "start with no ids"

      , equal (Db.tags 5 Db.empty)       Nothing    "no id to fetch"
      , equal (Db.ids "jersey" Db.empty) Nothing    "no tag to fetch"
      ]

addingAnAnimal : Test
addingAnAnimal =
  let
    added = Db.empty |> Db.addAnimal 5 ["jersey", "fractious"] 
    a = Array.fromList >> Just
  in
    concat
    [ describe "adding an animal"
        [ equal_ (Db.tags 5 added)             (a ["jersey", "fractious"])
        , equal_ (Db.ids "jersey" added)       (a [5])
        , equal  (Db.ids "fractious" added)    (a [5]) "both tags have 5"
        ]
    , describe "adding a second animal" <|
        let
          second = added |> Db.addAnimal 88 ["jersey", "down"]
        in
          [ equal_ (Db.tags 88 second)        (a ["jersey", "down"])
          , equal_ (Db.ids "jersey" second)   (a [5, 88])
          , equal_ (Db.ids "down" second)     (a [88])
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
            [ equal_ (Db.tags 5 new)       (a ["jersey", "fractious", "down"])
            , equal_ (Db.ids "down" new)   (a [5])
            ]
      , describe "multiple tags are allowed" <|
          let
            new = original |> Db.addTag 5 "jersey"
          in
            [ equal_ (Db.tags 5 new)       (a ["jersey", "fractious", "jersey"])
            ]
      ]

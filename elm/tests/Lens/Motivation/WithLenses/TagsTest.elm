module Lens.Motivation.WithLenses.TagsTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util exposing (..)
import Dict
import Array

import Lens.Motivation.WithLenses.Tags as Tags
import Lens.Motivation.WithLenses.TestAccess.Tags as Tags

empty : Test
empty =
    describe "empty"
      [ is (.allTags Tags.empty)   Dict.isEmpty  "start with no tags"
      , is (.allIds  Tags.empty)   Dict.isEmpty  "start with no ids"

      , equal (Tags.tags 5 Tags.empty)       Nothing    "no id to fetch"
      , equal (Tags.ids "jersey" Tags.empty) Nothing    "no tag to fetch"
      ]

addingAnAnimal : Test
addingAnAnimal =
  let
    added = Tags.empty |> Tags.addAnimal 5 ["jersey", "fractious"] 
    a = Array.fromList >> Just
  in
    concat
    [ describe "adding an animal"
        [ equal_ (Tags.tags 5 added)             (a ["jersey", "fractious"])
        , equal_ (Tags.ids "jersey" added)       (a [5])
        , equal  (Tags.ids "fractious" added)    (a [5]) "both tags have 5"
        ]
    , describe "adding a second animal" <|
        let
          second = added |> Tags.addAnimal 88 ["jersey", "down"]
        in
          [ equal_ (Tags.tags 88 second)        (a ["jersey", "down"])
          , equal_ (Tags.ids "jersey" second)   (a [5, 88])
          , equal_ (Tags.ids "down" second)     (a [88])
          ]
    ]
          


addingTag : Test
addingTag =
  let
    original = Tags.empty |> Tags.addAnimal 5 ["jersey", "fractious"]
          
    a = Array.fromList >> Just
  in
    concat
      [ describe "tags are added at the end" <|
          let
            new = original |> Tags.addTag 5 "down"
          in
            [ equal_ (Tags.tags 5 new)       (a ["jersey", "fractious", "down"])
            , equal_ (Tags.ids "down" new)   (a [5])
            ]
      , describe "multiple tags are allowed" <|
          let
            new = original |> Tags.addTag 5 "jersey"
          in
            [ equal_ (Tags.tags 5 new)       (a ["jersey", "fractious", "jersey"])
            ]
      ]

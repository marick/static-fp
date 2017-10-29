module Lens.Try3.OtherFunctionsTest exposing (..)

{- Tests for functions other than the code ones -}

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (..)
import Dict
import Array

import Lens.Try3.Lens as Lens

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result

d = Dict.singleton
             

hasJust : Test
hasJust =
  let
    try lens whole expected = 
      equal (Lens.hasJust lens whole) expected (toString whole)
  in
    describe "hasJust"
      [ describe "upsert lens" 
          [ try (Dict.lens "key")    Dict.empty      False
          , try (Dict.lens "key")    (d "---" 3)     False
          , try (Dict.lens "key")    (d "key" 3)     True
          ]
      , describe "humble lens"
          [ try (Dict.humbleLens "key")    Dict.empty      False
          , try (Dict.humbleLens "key")    (d "---" 3)     False
          , try (Dict.humbleLens "key")    (d "key" 3)     True
          ]
      ]
    
          
getWithDefault : Test
getWithDefault =
  let
    try lens whole expected = 
      equal (Lens.getWithDefault lens 8888 whole) expected (toString whole)
  in
    describe "getWithDefault"
      [ describe "upsert lens" 
          [ try (Dict.lens "key")    Dict.empty      (Just 8888)
          , try (Dict.lens "key")    (d "---" 3)     (Just 8888)
          , try (Dict.lens "key")    (d "key" 3)     (Just 3)
          ]
      , describe "humble lens"
          [ try (Dict.lens "key")    Dict.empty      (Just 8888)
          , try (Dict.lens "key")    (d "---" 3)     (Just 8888)
          , try (Dict.lens "key")    (d "key" 3)     (Just 3)
          ]
      ]
    
          
updateWithDefault : Test
updateWithDefault =
  let
    try lens whole expected = 
      equal (Lens.updateWithDefault lens 8888 negate whole) expected (toString whole)
  in
    describe "updateWithDefault"
      [ describe "upsert lens" 
          [ try (Dict.lens "key")    Dict.empty      (d "key" -8888)
          , try (Dict.lens "key")    (d "---" 3)     (d "---" 3 |> Dict.insert "key" -8888)
          , try (Dict.lens "key")    (d "key" 3)     (d "key" -3)
          ]
      ]
    
          

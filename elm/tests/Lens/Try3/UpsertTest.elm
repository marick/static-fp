module Lens.Try3.UpsertTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia, dict)
import Dict
import List.Extra as List

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Lens.Try3.ClassicTest as ClassicTest

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Dict as Dict


{- 
      The laws for this lens type are the same as for Classic lenses.
      Each law is checked with three values (old, new, and overwritten).
      For thoroughness, we check the laws with all eight combinations
      of those variables and (Just, Never). 
 -}

partCombinations original overwritten new =
  let
    maybes part =
      [Nothing, Just part]
    tuples =
      List.lift3 (,,) (maybes original) (maybes overwritten) (maybes new)
    recordify (a, b, c) =
      { original = a, overwritten = b, new = c }
  in
    List.map recordify tuples

tryCombination lens wholeMaker oneCombination = 
  let
    whole = wholeMaker oneCombination.original
  in
    ClassicTest.laws lens whole oneCombination (toString oneCombination)


{-
        The various predefined types obey the LAWS
        `Dict` has the only predefined lens of this kind.
 -}


lawTest : Test
lawTest =
  let
    lens =
      Dict.lens "key"

    wholeMaker original =
      case original of
        Nothing -> Dict.empty
        Just v -> dict "key" v

    combinations =
      partCombinations "OLD" "overwritten" "NEW"
  in
    describe "classic laws apply to Dict lenses" <|
      List.map (tryCombination lens wholeMaker) combinations

        
         
{-
         Check that `update` works correctly for each type
 -}

update : Test
update =
  let
    dictLens = (Dict.lens "key")
  in
    describe "update for various common base types"
      [ negateVia dictLens (dict "key" 3) (dict "key" -3)
      , negateVia dictLens (dict "---" 3) (dict "---"  3)
      , negateVia dictLens  Dict.empty     Dict.empty
      ]



          
{-
     Functions beyond the stock get/set/update
-}

exists : Test
exists =
  let
    exists lens whole expected = 
      equal (Lens.exists lens whole) expected (toString whole)
  in
    describe "exists"
      [ exists (Dict.lens "key")    Dict.empty         False
      , exists (Dict.lens "key")    (dict "---" 3)     False
      , exists (Dict.lens "key")    (dict "key" 3)     True
      ]

getWithDefault : Test
getWithDefault =
  let
    get lens whole expected = 
      equal (Lens.getWithDefault lens "default" whole) expected (toString whole)
  in
    describe "getWithDefault"
      [ get (Dict.lens "key")    Dict.empty            (Just "default")
      , get (Dict.lens "key")    (dict "---" "orig")   (Just "default")
      , get (Dict.lens "key")    (dict "key" "orig")   (Just "orig")
      ]
    
updateWithDefault : Test
updateWithDefault =
  let
    negateVia lens whole expected = 
      equal (Lens.updateWithDefault lens 8888 negate whole) expected (toString whole)
  in
    describe "updateWithDefault"
      [ negateVia (Dict.lens "key")    Dict.empty
                                      (dict "key" -8888)
          
      , negateVia (Dict.lens "key")    (dict "---" 3)
                                       (dict "---" 3 |> Dict.insert "key" -8888)
                                   
      , negateVia (Dict.lens "key")    (dict "key" 3)
                                       (dict "key" -3)
      ]
    
          
      

{-
      Converting other lenses into this type of lens
 -}

-- None

{- 
      Composing lenses to PRODUCE this type of lens
-}

classic_and_upsert : Test 
classic_and_upsert =
  let
    lens = Compose.classicAndUpsert Tuple2.first (Dict.lens "key")
  in
    describe "classic and upsert"
      [ describe "update"
          [ negateVia lens    ( (Dict.singleton "key"  3), "")
                              ( (Dict.singleton "key" -3), "")
              
          , negateVia lens    ( (Dict.singleton "---"  3), "")
                              ( (Dict.singleton "---"  3), "")
         
          , negateVia lens    (  Dict.empty,               "")
                              (  Dict.empty,               "")
          ]
      , describe "laws apply" <|
          let
            wholeMaker original =
              case original of
                Nothing -> (Dict.empty,   "")
                Just v ->  (dict "key" v, "")
            combinations =
              partCombinations 1 2 3
          in
            List.map (tryCombination lens wholeMaker) combinations
      ]

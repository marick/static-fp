module Lens.Final.Exercises.UpsertUpdateTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util as Util exposing (negateVia)
import Dict exposing (Dict)

-- CHANGE THE LINE BELOW TO TEST YOUR SOLUTION
import Lens.Final.Exercises.UpsertUpdateSolution as Lens
import Lens.Final.UpsertTest as Upsert



-- We need our own implementation of `Dict.upsertLens` because 
-- `Lens.Final.Dict` imports `Lens.Final.Lens`, and that 
-- module is the one we're rewriting. 

dictLens : comparable -> Lens.Upsert (Dict comparable val) val
dictLens key =
  Lens.upsert (Dict.get key) (Dict.insert key) (Dict.remove key)

{-         Types used to construct UPSERT lenses        -}

update : Test
update =
  describe "update for various common base types (upsert lenses)"
    [ negateVia (dictLens "key") (Dict.singleton "key"  3)
                                 (Dict.singleton "key" -3)

    , negateVia (dictLens "key") (Dict.singleton "---"  3)
                                 (Dict.singleton "---"  3)

    , negateVia (dictLens "key")  Dict.empty
                                  Dict.empty
    ]


lawTest : Test
lawTest =
  let
    lens =
      dictLens "key"

    wholeMaker original =
      case original of
        Nothing -> Dict.empty
        Just v -> Dict.singleton "key" v

    combinations =
      Upsert.partCombinations "OLD" "overwritten" "NEW"
  in
    describe "classic laws apply to Dict lenses" <|
      List.map (Upsert.tryCombination lens wholeMaker) combinations

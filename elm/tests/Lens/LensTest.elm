module Lens.LensTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Lens as Lens exposing (Lens)
import Lens.Tuple2 as Tuple2
import Dict exposing (Dict)

-- Note: the getters and setters are tested via the laws


update =
  equal (Lens.update Tuple2.second negate ("foo", 1))    ("foo", -1)  "update - basic"


updateDict =
  let
    whole = Dict.singleton "key" 3
    negatedWhole = Dict.singleton "key" -3
    keyPresent = Lens.dict "key"
    noSuchKey = Lens.dict "missing"
    negateM = Maybe.map negate
  in
    describe "dict is interesting - nothing new but worth showing"
      [ equal_ (Lens.update keyPresent negateM whole)  negatedWhole
      , equal_ (Lens.update noSuchKey  negateM whole)         whole
      ]
    

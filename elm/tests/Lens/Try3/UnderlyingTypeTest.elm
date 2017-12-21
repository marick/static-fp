module Lens.Try3.UnderlyingTypeTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (..)
import Dict
import Array

import Lens.Try3.Lens as Lens
import Lens.Try3.Laws as Laws

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Tuple3 as Tuple3
import Lens.Try3.Tuple4 as Tuple4
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result
import Lens.Try3.Maybe as Maybe




      

{-         Types used to construct OneCase lenses        -}

oneCaseUpdate : Test
oneCaseUpdate =
  describe "update for various common base types (one-case lenses)"
    [ upt Result.ok (Ok  3)  (Ok  -3)
    , upt Result.ok (Err 3)  (Err  3)

    , upt Result.err (Ok  3) (Ok   3)
    , upt Result.err (Err 3) (Err -3)

    , upt Maybe.just (Just 3)  (Just  -3)
    , upt Maybe.just Nothing   Nothing
    ]

      
oneCaseLaws : Test
oneCaseLaws =
  let
    legal = Laws.oneCase
  in
    describe "oneCase lenses obey the oneCase lens laws"
      [ legal Result.ok   Ok      "ok lens"
      , legal Result.err  Err     "err lens"

      , legal Maybe.just  Just    "just lens"
      ]



      

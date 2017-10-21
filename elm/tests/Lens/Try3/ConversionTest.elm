module Lens.Try3.ConversionTest exposing (..)

import Lens.Try3.Lens as Lens exposing (ClassicLens, get, set, update)
import Lens.Try3.Tuple2 as Tuple2
import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Laws as Laws
import Dict
import Lens.Try3.Dict as Dict
import Array
import Lens.Try3.Array as Array
import Lens.Try3.Util exposing (..)



classic_iffy : Test
classic_iffy =
  let
    lens = Lens.toIffy Tuple2.first
    (original, parts, present, missing) = iffyLawSupport

  in
    describe "lens to iffy lens"
      [ upt     lens   ( 3,       "")
                       (-3,       "")
      , present lens   (original, "")
      ]

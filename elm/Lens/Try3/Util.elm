module Lens.Try3.Util exposing (..)

import Lens.Try3.Lens as Lens exposing (GenericLens, get, set, update)
import Test exposing (..)
import TestBuilders exposing (..)

up lens whole expected =
  equal_ (update lens negate whole) expected



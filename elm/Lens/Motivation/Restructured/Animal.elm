module Lens.Motivation.Restructured.Animal exposing (..)

import Array exposing (Array)
import Lens.Try3.Lens as Lens

type alias Id = Int

type alias Animal =
  { id : Id
  , name : String
  }


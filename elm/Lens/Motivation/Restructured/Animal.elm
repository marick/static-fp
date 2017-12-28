module Lens.Motivation.Restructured.Animal exposing
  ( Animal
  , Id
  , named
  )

import Array exposing (Array)
import Lens.Final.Lens as Lens

type alias Id = Int

type alias Animal =
  { id : Id
  , name : String
  }

named : String -> Id -> Animal
named name id =
  { id = id
  , name = name
  }

module Lens.Motivation.Restructured.Animal exposing
  ( Animal
  , Id
  , named
  )

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

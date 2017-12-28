module Lens.Final.Exercises.Valid exposing (..)  

import Lens.Final.Lens as Lens

valid : Lens.OneCase String Int
valid =
  Lens.oneCase (String.toInt >> Result.toMaybe) toString

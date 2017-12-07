module Lens.Try3.Exercises.Valid exposing (..)  

import Lens.Try3.Lens as Lens

valid : Lens.OneCase String Int
valid =
  Lens.oneCase (String.toInt >> Result.toMaybe) toString

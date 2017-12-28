module Lens.Try4.Exercises.Valid exposing (..)  

import Lens.Try4.Lens as Lens

valid : Lens.OneCase String Int
valid =
  Lens.oneCase (String.toInt >> Result.toMaybe) toString

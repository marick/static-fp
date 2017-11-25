module Lens.Try3.Exercises.StringCase exposing (..)

import Lens.Try3.Lens as Lens
import Tagged exposing (Tagged(..))

dawn1 : Lens.OneCase String String
dawn1 =
  Lens.oneCase Just identity


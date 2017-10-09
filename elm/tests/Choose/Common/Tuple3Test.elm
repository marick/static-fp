module Choose.Common.Tuple3Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Lens as Lens
import Choose.Common.Tuple3 exposing (first, second, third)

suite : Test
suite =
  describe "lenses" 
      [ eql (Lens.update first  negate (1,  "", ""))  (-1 , "", "")
      , eql (Lens.update second negate ("", 1,  ""))  ("",  -1, "")
      , eql (Lens.update third  negate ("", "", 1))   ("", "", -1)
      ]

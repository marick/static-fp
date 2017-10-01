module Choose.Common.Tuple3Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Part as Part
import Choose.Common.Tuple3 exposing (first, second, third)

suite : Test
suite =
  describe "lenses" 
      [ eql (Part.update first  negate (1,  "", ""))  (-1 , "", "")
      , eql (Part.update second negate ("", 1,  ""))  ("",  -1, "")
      , eql (Part.update third  negate ("", "", 1))   ("", "", -1)
      ]

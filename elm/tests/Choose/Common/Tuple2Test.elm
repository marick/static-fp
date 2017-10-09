module Choose.Common.Tuple2Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Lens as Lens
import Choose.Common.Tuple2 exposing (first, second)

suite : Test
suite =
  describe "choosing elements" 
      [ eql (Lens.update first  negate (1  , "_"))  (-1 ,  "_")
      , eql (Lens.update second negate ("_", 1)  )  ("_",  -1)
      ]

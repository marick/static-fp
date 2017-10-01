module Choose.Common.Tuple2Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Part as Part
import Choose.Common.Tuple2 exposing (first, second)

suite : Test
suite =
  describe "choosing elements" 
      [ eql (Part.update first  negate (1  , "_"))  (-1 ,  "_")
      , eql (Part.update second negate ("_", 1)  )  ("_",  -1)
      ]

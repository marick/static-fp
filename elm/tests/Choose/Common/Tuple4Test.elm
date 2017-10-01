module Choose.Common.Tuple4Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Part as Part
import Choose.Common.Tuple4 exposing (first, second, third, fourth)

suite : Test
suite =
  describe "lenses" 
    [ eql (Part.update first   negate (1, "", "", ""))   (-1 , "", "", "")
    , eql (Part.update second  negate ("", 1, "", ""))   ("",  -1, "", "")
    , eql (Part.update third   negate ("", "", 1, ""))   ("", "", -1, "")
    , eql (Part.update fourth  negate ("", "", "", 1))   ("", "", "", -1)
    ]

    

module Choose.Common.Tuple4Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Lens as Lens
import Choose.Common.Tuple4 exposing (first, second, third, fourth)

suite : Test
suite =
  describe "lenses" 
    [ eql (Lens.update first   negate (1, "", "", ""))   (-1 , "", "", "")
    , eql (Lens.update second  negate ("", 1, "", ""))   ("",  -1, "", "")
    , eql (Lens.update third   negate ("", "", 1, ""))   ("", "", -1, "")
    , eql (Lens.update fourth  negate ("", "", "", 1))   ("", "", "", -1)
    ]

    

module Testing.StringTest exposing (..)

import Test exposing (..)
import Expect
import Fuzz
import TestUtil exposing (..)
import Result.Extra exposing (isErr, isOk)

suite : Test
suite =
  describe "String"
    [ describe "toInt"
        [ check "valid" (String.toInt "123") => Ok 123
        , check "invalid" (String.toInt "a") ==> isErr
        ]
    ]

-- Maybe have three types of fuzzing operators?
---- exact equality (not so useful)
---- a predicate that depends on actual value
---- a predicate that depends on the fuzz values
--
-- That last could allow this:
-- randomly "valid" Fuzz.int (toString >> String.toInt) ==> (=)
--   or could make "inverses" a special case?
    
fuzzSuite : Test
fuzzSuite =
  describe "FuzzString"
    [ describe "toInt"
        [ randomly "valid" Fuzz.int (toString >> String.toInt) ==> isOk
        ]
    , randomly "an example of `=>`"
        Fuzz.int (\_ -> 0) => 0
    ]

module ToInt.FixedStringClassifierTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import ToInt.FixedStringClassifier as Classifier exposing (Classified)
import ToInt.FixedString as Fixed 

absurdValues : Test
absurdValues =
  let
    try = tryExpecting Classifier.PreemptivelyBogus
  in
    describe "absurd values"
      [ describe "bugFixes"
          [ try "returned infinity" "-"
          , try "also returned infinity" "+"
          ]
      , describe "special cases for algorithm"
          [ try "-- prefix" "--3"
          , try "++ prefix" "++3"
          , try "-+ prefix" "-+3"
          , try "+1 prefix" "+-3"
          ]
      , try "empty string" ""
      ]

fineForToInt : Test
fineForToInt =
  let
    try = tryExpecting Classifier.SuitableForToInt
  in
    describe "fine for ToInt"
      [ try "short positive" "1"
      , try "short negative" "-1"

      --           maxInt = "2147483647"
      , try "long positive" "999999999"
      --           minInt = "-2147483648"
      , try "long negative" "-999999999"
      ]

tooLong : Test
tooLong =
  let
    try = tryExpecting Classifier.TooLong
  in
    describe "too long to be correct"
      [ --   maxInt =  "2147483647"
        try "positive" "10000000000" 
        --    minInt = "-2147483648"
      , try "negative" "-10000000000"
      ]

boundary : Test
boundary =
  describe "values that need special handling to determine if too big"
    [ tryExpecting Classifier.BoundaryPositive "positive" "2147483647"
    , tryExpecting Classifier.BoundaryNegative "negative" "-2147483648"
    ]

-- Utility    

tryExpecting : (String -> Classified String) -> String -> String -> Test
tryExpecting tag comment input =
  test comment <|
    \_ ->
      Classifier.classify input |> Expect.equal (tag input)

-- Check that boundary is consistent with our idea of the maximum and minumum
-- integer that `toInt` can handle. Might help discover cases where the boundary
-- was increased without the code being looked at carefully.
detectChanges : Test
detectChanges =
  let
    length int =
      String.length <| toString int
  in
    concat
      [ test "the boundary matches what's advertised as most positive" <| \_ ->
          Classifier.lengthBoundary
            |> Expect.equal (length Fixed.toIntMaxInt)
      , test "the boundary matches what's advertised as most negative" <| \_ ->
          Classifier.lengthBoundary + 1 -- +1 for minus sign
            |> Expect.equal (length Fixed.toIntMinInt)
      ]



        

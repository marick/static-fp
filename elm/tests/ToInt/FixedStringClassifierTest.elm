module ToInt.FixedStringClassifierTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import ToInt.FixedStringClassifier as Classifier exposing (Classified)


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
      

tryExpecting : (String -> Classified String) -> String -> String -> Test
tryExpecting tag comment input =
  test comment <|
    \_ ->
      Classifier.classify input |> Expect.equal (tag input)

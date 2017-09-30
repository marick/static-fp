module Array.ListGetTest exposing (..)

import Test exposing (..)
import TestBuilders as Build exposing (nothing, just)

import Array.ListGet as List

errorCases =
  describe "error cases"
    [ nothing (List.get  1 [0])  "past end of array"
    , nothing (List.get 0 [])    "ditto"
    , nothing (List.get -1 [0])  "negative index"
    ]

working =
  describe "successful cases"
    [ just (List.get 0 ["0"])        "0"  "only element"
    , just (List.get 0 ["0", "1"])   "0"  "first element"
    , just (List.get 1 ["0", "1"])   "1"  "last element"
    ]

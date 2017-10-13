module Choose.Common.ListTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Choose.Common.List as List
import Choose.MaybeLens as MaybeLens
import Choose.MaybeLensTest exposing (accessors)


first : Test
first =
  let
    (get, set, update) = accessors List.first
  in
    describe "first" 
      [ equal_ (get [])      Nothing
      , equal_ (get [1])     (Just 1)

      , equal_ (set 1 [])       [1]
      , equal_ (set 3 [1, 2])   [3, 2]

      , equal_ (update negate [])      []
      , equal_ (update negate [1, 2])  [-1, 2]
      ]

rest : Test
rest =
  let
    (get, set, update) = accessors List.rest
  in
    describe "rest" 
      [ equal_ (get [])      Nothing
      , equal_ (get [1])     (Just [])
      , equal_ (get [1, 2])  (Just [2])

      , equal_ (set [2] [0, 0])       [0, 2]
      , equal_ (set [ ] [0, 8])       [0   ]
      , equal  (set [3] [    ])       [    ]  "no head to use"

      , equal_ (update List.reverse [])          []
      , equal_ (update List.reverse [1, 2, 3])   [1, 3, 2]
      ]

-- The laws can't be tested in MaybeLensTest, which is written
-- so the parts are always `String`.
restLaws =
  let
    (get, set, _) = accessors List.rest
  in
    describe "laws for List.rest"
      [ -- 1. if you `set` the part that `get` provides, whole is unchanged
        equal (get     [1, 2])   (Just [2])      "here's what the get returns"
      , equal (set [2] [1, 2])      [1, 2]       "setting it to original"

      , equal (get    [1])    (Just [  ])        "not really a special case"
      , equal (set [] [1])         [1  ]         "but worth the demonstration"

      -- 2. What you `set` is what you `get`
      , equal_ (set [2] [1] |> get)  (Just [2])
      ]

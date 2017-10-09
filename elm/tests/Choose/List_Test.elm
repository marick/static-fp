module Choose.List_Test exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Choose.List_ as List_ exposing (List_(..))
import Choose.MaybeLens as MaybeLens
import Choose.MaybeLensTest exposing (accessors)

list1 : a -> List_ a
list1 one =
  Cons one Empty

list2 : a -> a -> List_ a
list2 one two =
  Cons one (Cons two Empty)

first : Test
first =
  let
    (get, set, update) = accessors List_.first
  in
    describe "first" 
      [ equal_ (get <| Empty)           Nothing
      , equal_ (get <| list1 1)         (Just 1)

      , equal_ (set 1 <| Empty  )       (list1 1)
      , equal_ (set 3 <| list2 1 2)     (list2 3 2)

      , equal_ (update negate Empty)        Empty
      , equal_ (update negate (list2 1 2))  (list2 -1 2)
      ]

firstLaws =
  let
    (get, set, _) = accessors List_.first
  in
    describe "laws for List.first"
      [ -- 1. if you `set` the part that `get` provides, whole is unchanged
        equal (get           (list2 1 2))   (Just 1)      "here's what the get returns"
      , equal (set 1 (list2 1 2))         (list2 1 2)       "setting it to original"

      -- 2. What you `set` is what you `get`
      , equal_ (set 2 (list1 1) |> get)    (Just 2)
      ]
      
rest : Test
rest =
  let
    (get, set, update) = accessors List_.rest
  in
    describe "rest" 
      [ equal_ (get <| Empty)       Nothing
      , equal_ (get <| list1 1)     (Just Empty)
      , equal_ (get <| list2 1 2)   (Just <| list1 2)

      , equal_ (set (list1 2) (list2 0 0))       (list2 0 2)
      , equal_ (set Empty     (list2 0 8))       (list1 0)
      , equal  (set (list1 3) Empty      )       Empty  "no head to use"
      ]

restLaws =
  let
    (get, set, _) = accessors List_.rest
  in
    describe "laws for List.rest"
      [ -- 1. if you `set` the part that `get` provides, whole is unchanged
        equal (get           (list2 1 2))   (Just <| list1 2)      "here's what the get returns"
      , equal (set (list1 2) (list2 1 2))         (list2 1 2)       "setting it to original"

      , equal (get       (list1 1))    (Just Empty)      "not really a special case"
      , equal (set Empty (list1 1))       (list1 1)      "but worth the demonstration"

      -- 2. What you `set` is what you `get`
      , equal_ (set (list1 2) (list1 1) |> get)    (Just (list1 2))
      ]

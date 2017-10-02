module Choose.MaybePartTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql, equal)
import Choose.MaybePart as Opt
import Dict

dict1 = Dict.singleton
dict1_1 outer inner val =
  dict1 outer (dict1 inner val)

operations : Test
operations =
  let
    chooseMe = Opt.make (Dict.get "me") (Dict.insert "me")

    get = Opt.get chooseMe
    set = Opt.set chooseMe
    update = Opt.update chooseMe
  in
    describe "operations" 
      [ eql (get <| dict1 "me" 58)    (Just 58)
      , eql (get <| Dict.empty)       Nothing

      , eql (set 0 <| dict1 "me" 3)   (dict1 "me" 0)
      , eql (set 9 <| Dict.empty)     (dict1 "me" 9)

      , eql (update negate <| dict1 "me" 58)    (dict1 "me" -58)
      , eql (update negate Dict.empty)          Dict.empty
      ]

laws =
  let
    chooseMe = Opt.make (Dict.get "me") (Dict.insert "me")
    get = Opt.get chooseMe
    set = Opt.set chooseMe
  in
    describe "laws"
      (let 
        d = dict1 "me" "val"  
       in
         [ -- 1. if you `set` the part that `get` provides, whole is unchanged
           equal (get d)        (Just "val")   "establish what the get returns"
         , equal (set "val" d)  d              "setting it changes nothing"

           -- 2. What you `set` is what you `get`
         , eql (get (set "new" d)) (Just "new")         
         ])

      

composition =
  let
    one = Opt.make (Dict.get "one") (Dict.insert "one")
    two = Opt.make (Dict.get "two") (Dict.insert "two")
    composed = one |> Opt.next two

    get = Opt.get composed
    set = Opt.set composed
    update = Opt.update composed
  in
    describe "composition"
      [ describe "get" 
          [ eql   (get <| dict1_1 "one" "two" 1.2)    (Just 1.2)
          , equal (get <| dict1_1 "one" "ZZZ" 1.2)    Nothing  "no last key"
          , equal (get <| dict1   "one" Dict.empty)   Nothing  "alternate of ^"
          , equal (get    Dict.empty)                 Nothing  "no first key"
          ]
      , describe "set"
          [ eql (set 8.8 <| dict1_1 "one" "two" 0)       (dict1_1 "one" "two" 8.8)
          , eql (set 2.2 <| dict1   "one" Dict.empty)    (dict1_1 "one" "two" 2.2)
          , eql (set 9.3 <| dict1   "TWO" Dict.empty)    (dict1   "TWO" Dict.empty)
          , eql (set 9.3 Dict.empty)                     Dict.empty
          ]
      , describe "update"
          [ eql (update negate <| dict1_1 "one" "two" 1)     (dict1_1 "one" "two" -1)
          , eql (update negate <| dict1   "one" Dict.empty)  (dict1   "one" Dict.empty)
          , eql (update negate    Dict.empty)                Dict.empty
          ]
      ]

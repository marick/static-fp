module Choose.MaybePartTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql, equal, equal_)
import Choose.MaybePart as Opt
import Choose.Common as Opt
import Choose.Definitions as D
import Dict

accessors partChooser =
  ( Opt.get partChooser
  , Opt.set partChooser
  , Opt.update partChooser
  )

operations : Test
operations =
  let
    (get, set, update) = accessors D.dictOpt
  in
    describe "operations" 
      [ eql (get <| D.dict1 "key" 58)    (Just 58)
      , eql (get <| Dict.empty)           Nothing

      , eql (set 0 <| D.dict1 "key" 3)   (D.dict1 "key" 0)
      , eql (set 9 <| Dict.empty)        (D.dict1 "key" 9)

      , eql (update negate <| D.dict1 "key" 58)    (D.dict1 "key" -58)
      , eql (update negate Dict.empty)             Dict.empty
      ]

lawTests opt whole wholeTag =
  let
    (get, set, _) = accessors opt
  in
    describe wholeTag
      [ -- 1. if you `set` the part that `get` provides, whole is unchanged
        equal (get whole)          (Just "focus")   "here's what the get returns"
      , equal (set "focus" whole)  whole            "setting it to original"

      -- 2. What you `set` is what you `get`
      , eql (get (set "new" whole))  <| Just "new"
      ]


laws =
  describe "laws for optionals (MaybePart)"
    [ lawTests D.dictOpt (D.dict1 "key" "focus")             "Dict"
        
    , lawTests (Opt.dict "one" |> Opt.next (Opt.dict "two"))
               (D.dict1_1 "one" "two" "focus")               "Composition"
          
    ]


composition =
  let
    composed = Opt.dict "one" |> Opt.next (Opt.dict "two")
    one = D.dict1_1 "one"
    one_ = D.dict1 "one"
    other = D.dict1_1 "other"
    (get, set, update) = accessors composed
  in
    describe "composition"
      [ describe "get" 
          [ equal_ (get <| one "two" 1.2)    (Just 1.2)
          , equal  (get <| one "ZZZ" 1.2)    Nothing  "no last key"
          , equal  (get <| one_ Dict.empty)  Nothing  "alternate to above"
          , equal  (get <| Dict.empty)       Nothing  "no first key"
          ]
      , describe "set"
          [ eql (set 8.8 <| one  "two" 0000)    (one "two" 8.8)
          , eql (set 2.2 <| one_ Dict.empty)    (one "two" 2.2)
          , eql (set 9.3 <| other "two" 0000)   (Dict.union (other "two" 0000)
                                                            (one "two" 9.3))
          , eql (set 9.3 Dict.empty)            (one "two" 9.3)
          ]
      , describe "update"
          [ eql (update negate <| D.dict1_1 "one" "two" 1)     (D.dict1_1 "one" "two" -1)
          , eql (update negate <| D.dict1   "one" Dict.empty)  (D.dict1   "one" Dict.empty)
          , eql (update negate <| Dict.empty)                  Dict.empty
          ]
      ]

module Choose.PartTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql, equal)
import Choose.Part as Part
import Choose.Combine.Part as Part
import Choose.Common.Tuple2 exposing (second)
import Choose.Definitions exposing (..)


--- More commonly called Lenses

operations : Test
operations =
  let
    record = {part = 3}
    part = oneLevelLens
  in
    describe "operations" 
      [ eql (Part.get    part        record)           3
      , eql (Part.set    part 5      record) { part =  5 }
      , eql (Part.update part negate record) { part = -3 }
      ]


--- Some examples of Lens laws
recordsFollowLaws =
  let 
    record = {part = "old"}
    part = Part.make .part (\part whole -> { whole | part = part })

    get = Part.get part
    set = Part.set part
  in
    describe "laws for typical record"
      [ equal (get (set "new" record)) "new"
                        "you get back what you put in"
      , equal (set (get record) record) record
                        "putting back what you get changes nothing"
      , equal (record |> set "ignore" |> set "new")
              (record |>                 set "new")
                        "later `set`s overwrite earlier"
      ]


tuplesFollowLaws =
  let 
    tuple = (0, "old")
    get = Part.get second
    set = Part.set second
  in
    describe "laws for typical tuple"
      [ equal (get (set "new" tuple)) "new"
                        "you get back what you put in"
      , equal (set (get tuple) tuple) tuple
                        "putting back what you get changes nothing"
      , equal (tuple |> set "overwritten" |> set "new")
              (tuple |>                      set "new")
                        "later `set`s overwrite earlier"
      ]

-- Combinations

withLens : Test
withLens =
  let
    record = { part = (1, {part = 2}) }
    part = Part.make .part (\part whole -> { whole | part = part })
    chain = part |> Part.next second |> Part.next part
  in
    describe "composition" 
      [ eql (Part.get chain record)                           2
      , eql (Part.update chain negate record) { part = (1, {part = -2}) }
      ]

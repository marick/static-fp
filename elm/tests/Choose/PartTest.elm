module Choose.PartTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql, equal)
import Choose.Part as Lens exposing (Lens)
import Choose.Combine.Part as Lens
import Choose.Common.Tuple2 as Tuple2
import Choose.Definitions as D 


accessors partChooser =
  ( Lens.get partChooser
  , Lens.set partChooser
  , Lens.update partChooser
  )

--- More commonly called Lenses

operations : Test
operations =
  let
    whole = {part = 3}
    (get, set, update) = accessors D.oneLevelLens
  in
    describe "operations" 
      [ eql (get           whole)           3
      , eql (set    5      whole) { part =  5 }
      , eql (update negate whole) { part = -3 }
      ]


--- Some examples of Lens laws


lawTests lens whole wholeTag =
  let
    (get, set, _) = accessors lens
  in
    describe wholeTag
      [ -- 1. You get back what you put in"
        eql (get (set "NEW" whole)) "NEW"

        -- 2. Setting what you get changes results in original value
      , eql (set (get whole) whole) whole

        -- 3. A later `set` overwrites an earlier one.
      , eql (whole |> set "overwritten" |> set "new")
            (whole |>                      set "new")
      ]

laws =
  describe "laws for lenses" 
    [ lawTests D.oneLevelLens   {part = "focus"}     "records"
    , lawTests Tuple2.second    (0,     "focus")     "2-elt tuples"
    ]


combinationsFollowLaws =
  describe "laws for combinations"
    [ lawTests (D.oneLevelLens |> Lens.next Tuple2.second)
               { part = (1, "focus") }
               "combinations of parts"
    ]

module Choose.PartTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (eql)
import Choose.Part as Part
import Choose.Common.Tuple2 exposing (second)

operations : Test
operations =
  let
    record = {i = 3}
    part = Part.make .i (\part whole -> { whole | i = part })
  in
    describe "operations" 
      [ eql (Part.get    part        record)        3
      , eql (Part.set    part 5      record) { i =  5 }
      , eql (Part.update part negate record) { i = -3 }
      ]
       
composition : Test
composition =
  let
    record = { i = (1, {i = 2}) }
    part = Part.make .i (\part whole -> { whole | i = part })
    chain = part |> Part.next second |> Part.next part
  in
    describe "composition" 
      [ eql (Part.get chain record)                           2
      , eql (Part.update chain negate record) { i = (1, {i = -2}) }
      ]

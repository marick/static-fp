module Lens.Try3.ClassicTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia)
import Tagged exposing (Tagged(..))

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Tuple3 as Tuple3
import Lens.Try3.Tuple4 as Tuple4


{-
     Types used to construct classic lenses 
 -}

type alias Record a =
  { part : a
  }

record = Lens.classic .part (\part whole -> { whole | part = part })


{- 
     The laws for this lens type 
 -}

laws lens whole inputValues comment = 
  describe comment
    [ set_get lens whole inputValues
    , get_set lens whole 
    , set_set lens whole inputValues
    ]

set_get (Tagged {get, set}) whole {new} =
  equal (get (set new whole)) new
    "value set can then be gotten"

get_set (Tagged {get, set}) whole = 
  equal (set (get whole) whole) whole
    "setting with the gotten value leaves the whole unchanged"

set_set (Tagged {set}) whole {overwritten, new} = 
  let
    inOneStep  = whole |>                    set new
    inTwoSteps = whole |> set overwritten |> set new
  in
    equal inTwoSteps   inOneStep
      "set changes only the given part (no counter, etc.)"


{-
     The various predefined types obey the LAWS
 -}

         
lawTest : Test
lawTest =
  let
    (original, legal) = lawValues
  in
    describe "laws checked for various classic lenses"
      [ legal record         {part = original}       

      , legal Tuple2.first   (original, "")          
      , legal Tuple2.second  ("", original)          

      , legal Tuple3.first   (original, "", "")      
      , legal Tuple3.second  ("", original, "")      
      , legal Tuple3.third   ("", "", original)      

      , legal Tuple4.first   (original, "", "", "")  
      , legal Tuple4.second  ("", original, "", "")  
      , legal Tuple4.third   ("", "", original, "")  
      , legal Tuple4.fourth  ("", "", "", original)  
      ]


lawValues =
  let 
    original = "OLD"
    parts =
      { original = original
      , new = "NEW"
      , overwritten = "overwritten"
      }
    legal lens whole =
      laws lens whole parts (toString whole)
  in
    (original, legal)
    
{-
         Check that `update` works correctly for each type
         (overkill, really)
 -}

update : Test
update =
  describe "update for various common base types (classic lenses)"
    [ negateVia record         {part = 3}        {part = -3}
        
    , negateVia Tuple2.first   (3, "")           (-3, "")
    , negateVia Tuple2.second  ("", 3)           ("", -3)
      
    , negateVia Tuple3.first   (3, "", "")       (-3, "", "")
    , negateVia Tuple3.second  ("", 3, "")       ("", -3, "")
    , negateVia Tuple3.third   ("", "", 3)       ("", "", -3)
      
    , negateVia Tuple4.first   (3, "", "", "")   (-3, "", "", "")
    , negateVia Tuple4.second  ("", 3, "", "")   ("", -3, "", "")
    , negateVia Tuple4.third   ("", "", 3, "")   ("", "", -3, "")
    , negateVia Tuple4.fourth  ("", "", "", 3)   ("", "", "", -3)
    ]
  

{-
      Converting other lenses into this type of lens
 -}

-- None

{- 
      Composing lenses to PRODUCE this type of lens
-}


classic_and_classic : Test 
classic_and_classic =
  let
    lens = Compose.classicAndClassic Tuple2.first Tuple2.second
    (original, legal) = lawValues
  in
    describe "classic ..>> classic"
      [ negateVia lens (("",        3), "")
                       (("",       -3), "")

      , legal     lens (("", original), "")
      ]

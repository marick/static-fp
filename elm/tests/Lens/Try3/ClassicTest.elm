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

makeLawTest lens whole parts comment = 
  describe comment
    [ set_get lens whole parts
    , get_set lens whole 
    , set_set lens whole parts
    ]

-- Constant values to use for various law tests.
-- Their values are irrelevant, thus making them
-- decent standins for variables in lens laws.
-- In special cases, `makeLawTest` will be used
-- with different parts
defaultParts =
  { original = "old"
  , new = "NEW"
  , overwritten = "overwritten"
  }
original = defaultParts.original

-- The most common use of `makeLawTest`:  
legal lens whole =
  makeLawTest lens whole defaultParts (toString whole)

{-
     The various predefined types obey the LAWS
 -}
         
laws : Test
laws =
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
    
{-
         Check that `update` works correctly for each type.
         (Overkill, really, since every type uses the same `update` code,
         which depends only on the correctness of `get` and `set`.)
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
  in
    describe "classic ..>> classic"
      [ negateVia lens (("",        3), "")
                       (("",       -3), "")

      , legal     lens (("", original), "")
      ]

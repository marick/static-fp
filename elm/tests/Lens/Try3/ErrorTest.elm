module Lens.Try3.ErrorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia, dict, array)
import Tagged exposing (Tagged(..))
import Lens.Try3.ClassicTest as ClassicTest

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Result.Extra as Result
import Dict
import Array
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result
import Lens.Try3.Tuple2 as Tuple2




{- 
     The laws for this lens type 
 -}

presentLaws lens whole ({original, new} as inputValues) = 
  describe "`get whole` would succeed"
    [ -- describe required context
      notEqual original new           "equal values would be a weak test case"  
     
    ,             set_get lens whole inputValues
    ,             get_set lens whole inputValues
    , ClassicTest.set_set lens whole inputValues
    ]

missingLaws lens whole inputValues why = 
  describe ("`get whole` would fail: " ++ why)
    [ no_upsert lens whole inputValues
    ]

-- These laws are the same as those for the humble lens, except for
-- the use of `Result` instead of `Maybe`.
      
set_get (Tagged {get, set}) whole {original, new} =
  describe "when a part is present, `set` overwrites it"
    [ -- describe required context
      equal  (get          whole)    (Ok original)  "part must be present"

    , equal_ (get (set new whole))   (Ok new)
    ]

get_set (Tagged {get, set}) whole {original} =
  describe "retrieving a part, then setting it back"
    [ -- describe required context
      equal  (get          whole)     (Ok original)  "part must be present"
        
    , equal_ (set original whole)     whole
    ]

no_upsert (Tagged {get, set}) whole {new} = 
  describe "when a part is missing, `set` does nothing"
    [ -- describe required context
      is    (get          whole)      Result.isErr   "part must be misssing"
        
    , is    (get (set new whole))     Result.isErr   "`set` does not add anything"
    , equal      (set new whole)      whole          "nothing else changed"
    ]


{-
     The various predefined types obey the LAWS
 -}

laws : Test
laws =
  let
    (original, present, missing) = lawValues
  in
    describe "error lenses obey the error lens laws"
      [ describe "array lens"
          [ present (Array.errorLens 1)   (array [' ', original])
          , missing (Array.errorLens 1)   (array [' '          ])   "array too short"
          ]

      , describe "dict lens"
          [ present (Dict.errorLens "key") (dict "key" original)
          , missing (Dict.errorLens "key") (dict "---" original)  "no such key"
          , missing (Dict.errorLens "key")  Dict.empty            "empty dict"
          ]
      ]

lawValues =
  let 
    original = '1'
    parts =
      { original = original
      , overwritten = '-'
      , new = '2'
      }
    present lens whole =
      presentLaws lens whole parts
    missing lens whole why = 
      missingLaws lens whole parts why
  in
    (original, present, missing)


      
{-
         Check that `update` works correctly for each type.
         (Overkill, really, since every type uses the same `update` code,
         which depends only on the correctness of `get` and `set`.)
 -}

update : Test
update =
  let
    at0 = Array.errorLens 0
    at1 = Array.errorLens 1

    dictLens = Dict.errorLens "key"
  in
    describe "update for various common base types (error lenses)"
      [ negateVia at0   (array [3])    (array [-3])
      , negateVia at1   (array [3])    (array [ 3])
      , negateVia at1   Array.empty    Array.empty
        
      , negateVia dictLens (dict "key" 3)   (dict "key" -3)
      , negateVia dictLens (dict "---" 3)   (dict "---"  3)
      , negateVia dictLens Dict.empty       Dict.empty
      ]
  
      
{-
      Converting other lenses into this type of lens
 -}

        

{- 
      Composing lenses to PRODUCE this type of lens
-}

-- error_and_error : Test 
-- error_and_error =
--   let
--     lens = Compose.errorAndError (Array.lens 0) (Array.lens 1)
--     (original, present, missing) = lawValues

--     a2 = List.map array >> array
--   in
--     describe "error + error"
--       [ describe "update"
--           [ negateVia lens   (a2 [[0, 3]])   (a2 [[0, -3]])
--           , negateVia lens   (a2 [[0   ]])   (a2 [[0    ]])
--           , negateVia lens   (a2 [[    ]])   (a2 [[     ]])
--           ]
--       , describe "laws"
--           [ present lens  (a2 [[' ', original]])
--           , missing lens  (a2 [[' '          ]])       "short"
--           , missing lens  (a2 [              ])        "missing"
--           ]
--       ]

-- classic_and_humble : Test
-- classic_and_humble =
--   let
--     lens = Compose.classicAndHumble Tuple2.second (Array.lens 1)
--     (original, present, missing) = lawValues

--     nested oneElt =
--       ( array [] , array oneElt )
--   in
--     describe "classic + humble"
--       [ describe "update"
--         [ negateVia lens   (nested [5, 3])   (nested [5, -3])
--         , negateVia lens   (nested [    ])   (nested [     ])
--         , negateVia lens   (nested [3   ])   (nested [3    ])
--           ]
--       , describe "laws"
--         [ present lens  (nested ['a', original])
--         , missing lens  (nested ['a'          ])    "no second element"
--         ]
--       ]

-- upsert_and_classic : Test
-- upsert_and_classic =
--   let
--     lens = Compose.upsertAndClassic (Dict.lens "key") (Tuple2.first)
--     (original, present, missing) = lawValues
--   in
--     describe "upsert and classic"
--       [ describe "update"
--           [ negateVia lens   (dict "key" (3, ""))   (dict "key" (-3, ""))
--           , negateVia lens   (dict "---" (3, ""))   (dict "---" ( 3, ""))
--           , negateVia lens   Dict.empty             Dict.empty
--           ]
--       , describe "laws"
--           [ present lens  (dict "key" (original, ""))
--           , missing lens  (dict "---" (original, ""))    "wrong key"
--           , missing lens  Dict.empty                     "missing"
--           ]
--       ]


-- onecase_and_classic : Test
-- onecase_and_classic =
--   let
--     lens = Compose.oneCaseAndClassic Result.ok Tuple2.first
--     (original, present, missing) = lawValues
--   in
--     describe "one-case and classic"
--       [ negateVia lens  (Ok  (3, ""))    (Ok  (-3, ""))
--       , negateVia lens  (Err (3, ""))    (Err ( 3, ""))

--       , present lens (Ok (original, ""))
--       , missing lens (Err original)   "different case"
--       ]
      
      
{- Functions beyond the stock get/set/update -}


-- exists : Test
-- exists =
--   let
--     exists lens whole expected = 
--       equal (Lens.exists lens whole) expected (toString whole)
--   in
--     describe "exists"
--       [ exists (Dict.humbleLens "key")    Dict.empty       False
--       , exists (Dict.humbleLens "key")    (dict "---" 3)   False
--       , exists (Dict.humbleLens "key")    (dict "key" 3)   True
--       ]

-- getWithDefault : Test
-- getWithDefault =
--   let
--     get lens whole expected = 
--       equal (Lens.getWithDefault lens "default" whole) expected (toString whole)
--   in
--     describe "getWithDefault"
--       [ get (Dict.humbleLens "key")    Dict.empty            (Just "default")
--       , get (Dict.humbleLens "key")    (dict "---" "orig")   (Just "default")
--       , get (Dict.humbleLens "key")    (dict "key" "orig")   (Just "orig")
--       ]
      
-- setM : Test
-- setM =
--   let
--     setM = 
--       Lens.setM (Dict.humbleLens "key")
--   in
--     describe "setM"
--       [ equal  (setM 88 <| Dict.empty)    Nothing      "empty"
--       , equal  (setM 88 <| dict "---" 0)  Nothing      "bad key"
--       , equal_ (setM 88 <| dict "key" 0) (Just <| dict "key" 88)  
--       ]

-- updateM : Test
-- updateM =
--   let
--     lens =
--       Dict.humbleLens "key"
--     negateVia lens = 
--       Lens.updateM lens Basics.negate 
--   in
--     describe "updateM"
--       [ equal  (negateVia lens <| Dict.empty)    Nothing      "empty"
--       , equal  (negateVia lens <| dict "---" 8)  Nothing      "bad key"
--       , equal_ (negateVia lens <| dict "key" 8) (Just <| dict "key" -8)  
--       ]

      

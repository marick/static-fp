module Lens.Try3.ErrorTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia, dict, array)
import Tagged exposing (Tagged(..))
import Lens.Try3.ClassicTest as ClassicTest

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Result.Extra as Result exposing (isErr)
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
      is    (get          whole)      isErr    "part must be misssing"
        
    , is    (get (set new whole))     isErr     "`set` does not add anything"
    , equal      (set new whole)      whole     "nothing else changed"
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
     Functions beyond the stock get/set/update
-}

setR : Test
setR =
  let
    setR = 
      Lens.setR (Dict.errorLens "key")
  in
    describe "setR"
      [ is     (setR 88 <| Dict.empty)       isErr          "empty"
      , is     (setR 88 <| dict "---" 0)     isErr          "bad key"
      , equal_ (setR 88 <| dict "key" 0)     (Ok <| dict "key" 88)  
      ]

updateR : Test
updateR =
  let
    lens =
      Dict.errorLens "key"
    negateVia lens = 
      Lens.updateR lens negate 
  in
    describe "updateM"
      [ is     (negateVia lens <| Dict.empty)    isErr      "empty"
      , is     (negateVia lens <| dict "---" 8)  isErr      "bad key"
      , equal_ (negateVia lens <| dict "key" 8) (Ok <| dict "key" -8)  
      ]


      
{-
      Converting other lenses into this type of lens
 -}

from_humble : Test
from_humble =
  let
    lens = Compose.humbleToError toString (Dict.humbleLens "key")
    (original, present, missing) = lawValues
    get = Lens.get lens 
  in
    describe "upsert to humble lens"
      [ describe "get" 
          [ equal_   (get (dict "key" 3))   (Ok 3)
          , equal_   (get (dict "---" 3))   (Err <| toString (dict "---" 3))
          ]
      , describe "update"
          [ negateVia    lens   (dict "key"  3)
                                (dict "key" -3)
          , negateVia    lens    Dict.empty
                                 Dict.empty
          ]
      , describe "laws"
          [ present lens  (dict "key" original)
          , missing lens  (dict "---" original)   "wrong key"
          , missing lens   Dict.empty             "empty"
          ]
      ]

{- 
      Composing lenses to PRODUCE this type of lens
-}

error_and_error : Test 
error_and_error =
  let
    lens = Compose.errorAndError (Array.errorLens 0) (Array.errorLens 1)
    (original, present, missing) = lawValues

    a2 = List.map array >> array
  in
    describe "error and error"
      [ describe "update"
          [ negateVia lens   (a2 [[0, 3]])   (a2 [[0, -3]])
          , negateVia lens   (a2 [[0   ]])   (a2 [[0    ]])
          , negateVia lens   (a2 [[    ]])   (a2 [[     ]])
          ]
      , describe "laws"
          [ present lens  (a2 [[' ', original]])
          , missing lens  (a2 [[' '          ]])       "short"
          , missing lens  (a2 [              ])        "missing"
          ]
      ]

      
      

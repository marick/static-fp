module Lens.Try3.AlarmistTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia, dict, array)
import Tagged exposing (Tagged(..))

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

-- Even where the laws have the same meaning as for the classic lens, the type
-- signatures are too different to reuse them. The exception is that the Classic
-- `set_set` lens can be reused.

{- 


set_get (Tagged {get, set}) whole {original, new} =
  describe "when a part is present, `set` overwrites it"
    [ -- describe required context
      equal  (get          whole)    (Just original)  "part must be present"

    , equal_ (get (set new whole))   (Just new)
    ]

get_set (Tagged {get, set}) whole {original} =
  describe "retrieving a part, then setting it back"
    [ -- describe required context
      equal  (get          whole)     (Just original)  "part must be present"
        
    , equal_ (set original whole)     whole
    ]
-}

no_upsert (Tagged {get, set}) whole {new} = 
  describe "when a part is missing, `set` fails"
    [ -- describe required context
      is (get     whole)   Result.isErr    "part must be misssing"
        
    , is (set new whole)  Result.isErr       "`set` does not add anything"
    ]

-- Laws are separated into present/missing cases because some types
-- will have more than one way for a part to be missing

{- 
    
makeLawTest_present lens whole ({original, new} as inputValues) = 
  describe "`get whole` would succeed"
    [ -- describe required context
      notEqual original new           "equal values would be a weak test case"  
     
    ,             set_get lens whole inputValues
    ,             get_set lens whole inputValues
    , ClassicTest.set_set lens whole inputValues
    ]

makeLawTest_missing lens whole inputValues why = 
  describe ("`get whole` would fail: " ++ why)
    [ no_upsert lens whole inputValues
    ]
-}

-- Constant values to use for various law tests.
-- Their values are irrelevant, thus making them
-- decent standins for variables in lens laws.
defaultParts = 
  { original = 'a'
  , overwritten = '-'
  , new = '2'
  }
original = defaultParts.original  


-- The most common way to use law tests

{- 

present lens whole =
  makeLawTest_present lens whole defaultParts
    
missing lens whole why = 
  makeLawTest_missing lens whole defaultParts why
-}

{-
     The various predefined types obey the LAWS
 -}


array_laws : Test
array_laws =
  let
    lens = Array.alarmistLens 1
    underlyingSetter = Array.set 1
  in
    describe "array lenses obey the alarmist lens laws"
      [ no_upsert lens Array.empty defaultParts 
      ]


{- 
laws : Test
laws =
  describe "alarmist lenses obey the alarmist lens laws"
    [ describe "array lens"
        [ present (Array.lens 1)   (array [' ', original])
        , missing (Array.lens 1)   (array [' '          ])   "array too short"
        ]

    , describe "dict lens"
      [ present (Dict.alarmistLens "key") (dict "key" original)
      , missing (Dict.alarmistLens "key") (dict "---" original)  "no such key"
      , missing (Dict.alarmistLens "key")  Dict.empty            "empty dict"
      ]
    ]
 -}
    
{-
         Check that `update` works correctly for each type.
         (Overkill, really, since every type uses the same `update` code,
         which depends only on the correctness of `get` and `set`.)
 -}

{- 
update : Test
update =
  let
    at0 = Array.lens 0
    at1 = Array.lens 1

    dictLens = Dict.alarmistLens "key"
  in
    describe "update for various common base types (alarmist lenses)"
      [ negateVia at0   (array [3])    (array [-3])
      , negateVia at1   (array [3])    (array [ 3])
      , negateVia at1   Array.empty    Array.empty
        
      , negateVia dictLens (dict "key" 3)   (dict "key" -3)
      , negateVia dictLens (dict "---" 3)   (dict "---"  3)
      , negateVia dictLens Dict.empty       Dict.empty
      ]
 -}

{- 
    set and update produce error lists
-}

set_failure : Test
set_failure =
  let
    lens = Dict.alarmistLens "key"
    whole = dict "not key" 3
    expected = { whole = whole , path = ["`\"key\"`"] }
  in
    describe "set produces error lists"
      [ equal_ (Lens.set lens 33 whole) (Err expected)
      ]

update_failure : Test
update_failure =
  let
    lens = Array.alarmistLens 3
    whole = Array.empty
    expected = { whole = whole, path = ["`3`"] }
  in
    describe "update produces error lists"
      [ equal_ (Lens.set lens 33 whole) (Err expected)
      ]

{-
    Functions beyond the stock get/set/update
 -}


{- 
exists : Test
exists =
  let
    exists lens whole expected = 
      equal (Lens.exists lens whole) expected (toString whole)
  in
    describe "exists"
      [ exists (Dict.alarmistLens "key")    Dict.empty       False
      , exists (Dict.alarmistLens "key")    (dict "---" 3)   False
      , exists (Dict.alarmistLens "key")    (dict "key" 3)   True
      ]
 -}

{- 
getWithDefault : Test
getWithDefault =
  let
    get lens whole expected = 
      equal (Lens.getWithDefault lens "default" whole) expected (toString whole)
  in
    describe "getWithDefault"
      [ get (Dict.alarmistLens "key")    Dict.empty            (Just "default")
      , get (Dict.alarmistLens "key")    (dict "---" "orig")   (Just "default")
      , get (Dict.alarmistLens "key")    (dict "key" "orig")   (Just "orig")
      ]
 -}
      
{- 
setM : Test
setM =
  let
    setM = 
      Lens.setM (Dict.alarmistLens "key")
  in
    describe "setM"
      [ equal  (setM 88 <| Dict.empty)    Nothing      "empty"
      , equal  (setM 88 <| dict "---" 0)  Nothing      "bad key"
      , equal_ (setM 88 <| dict "key" 0) (Just <| dict "key" 88)  
      ]
 -}

{- 
updateM : Test
updateM =
  let
    lens =
      Dict.alarmistLens "key"
    negateVia lens = 
      Lens.updateM lens Basics.negate 
  in
    describe "updateM"
      [ equal  (negateVia lens <| Dict.empty)    Nothing      "empty"
      , equal  (negateVia lens <| dict "---" 8)  Nothing      "bad key"
      , equal_ (negateVia lens <| dict "key" 8) (Just <| dict "key" -8)  
      ]
 -}

      


      
{-
      Converting other lenses into this type of lens
 -}


{- 
      Composing lenses to PRODUCE this type of lens
-}


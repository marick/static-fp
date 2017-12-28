module Lens.Try3.AlarmistTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (dict, array)
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

set_get (Tagged {get, set}) underlyingSetter whole {original, new} =
  let
    afterSet = underlyingSetter new whole
  in
    describe "when a part is present, `set` overwrites it"
      [ -- describe required context
        equal  (get whole)     (Ok original)  "part must be present"
          
        -- describe what `set` must produce
      , equal_ (set new whole) (Ok afterSet)
        -- and here's the set-then-get`
      , equal_ (get afterSet)  (Ok new)
      ]



get_set (Tagged {get, set}) whole {original} =
  describe "retrieving a part, then setting it back"
    [ -- describe required context
      equal  (get          whole)     (Ok original)  "part must be present"
        
    , equal_ (set original whole)     (Ok whole)
    ]


set_set (Tagged {set}) underlyingSetter whole {overwritten, new} = 
  let
    inOneStep  = whole             |> set new
                 
    inTwoSteps = intermediateWhole |> set new    -- (*)
    intermediateWhole = underlyingSetter overwritten whole
  in
    describe "set changes only the given part (no counter, etc.)"
      [ -- describe required context
        equal (set overwritten whole) (Ok intermediateWhole)
                                      "the first of two steps produces what (*) uses"
      , equal_ inTwoSteps inOneStep
      ]
      

        
no_upsert (Tagged {get, set}) whole {new} = 
  describe "when a part is missing, `set` fails"
    [ -- describe required context
      is (get     whole)   Result.isErr    "part must be misssing"
        
    , is (set new whole)  Result.isErr       "`set` does not add anything"
    ]

-- Laws are separated into present/missing cases because some types
-- will have more than one way for a part to be missing

makeLawTest_present lens underlyingSetter whole ({original, new, overwritten} as inputValues) = 
  describe "`get whole` would succeed"
    [ -- describe required context
      notEqual original new           "equal values would be a weak test case"  
    , notEqual original overwritten   "same for these"  
    , notEqual new      overwritten   "and these"  
     
    , set_get lens underlyingSetter whole inputValues
    , get_set lens                  whole inputValues
    , set_set lens underlyingSetter whole inputValues
    ]

makeLawTest_missing lens whole inputValues why = 
  describe ("`get whole` would fail: " ++ why)
    [ no_upsert lens whole inputValues
    ]

-- Constant values to use for various law tests.
-- Their values are irrelevant, thus making them
-- decent standins for variables in lens laws.
defaultParts = 
  { original = 1.1
  , overwritten = 2.2
  , new = 3.3
  }
original = defaultParts.original  


-- The most common way to use law tests

present lens underlyingSetter whole =
  makeLawTest_present lens underlyingSetter whole defaultParts
    
missing lens whole why = 
  makeLawTest_missing lens whole defaultParts why

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
      [ present lens underlyingSetter (array [3, original])

      , missing lens                  Array.empty   "too short"
      ]

dict_laws : Test
dict_laws = 
  let
    lens = Dict.alarmistLens "key"
    underlyingSetter = Dict.insert "key"
  in
    describe "dict lenses obey the alarmist lens laws"
      [ present lens underlyingSetter (dict "key" original)

      , missing lens                  (dict "---" original)  "missing key"
      , missing lens                  Dict.empty             "empty"
      ]
    
{-
         Check that `update` works correctly for each type.
 -}

update : Test
update =
  let
    at0 = Array.alarmistLens 0
    at1 = Array.alarmistLens 1

    dictLens = Dict.alarmistLens "key"

    negateVia lens = Lens.update lens negate -- can't use Util.negateVia
  in
    describe "update for various common base types (alarmist lenses)"
      [ equal_ (negateVia at0 <| array [3])     (Ok <| array [-3])
      , is_    (negateVia at0 <| Array.empty)   Result.isErr
      , is_    (negateVia at1 <| array [3])     Result.isErr
        
      , equal_ (negateVia dictLens <| dict "key" 3)   (Ok <| dict "key" -3)
      , is_    (negateVia dictLens <| dict "---" 3)   Result.isErr
      , is_    (negateVia dictLens <| Dict.empty)     Result.isErr
      ]

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

-- `exists` isn't type-compatible, so we have a different one.
pathExists : Test
pathExists =
  let
    exists lens whole expected = 
      equal (Lens.pathExists lens whole) expected (toString whole)
  in
    describe "exists"
      [ exists (Dict.alarmistLens "key")    Dict.empty       False
      , exists (Dict.alarmistLens "key")    (dict "---" 3)   False
      , exists (Dict.alarmistLens "key")    (dict "key" 3)   True
      ]
      
{-
      Converting other lenses into this type of lens
 -}


{- 
      Composing lenses to PRODUCE this type of lens
-}


module Lens.Final.PathTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util as Util exposing (dict, array)
import Tagged exposing (Tagged(..))

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Compose
import Result.Extra as Result

import Dict
import Array
import Lens.Final.Dict as Dict
import Lens.Final.Array as Array
import Lens.Final.Result as Result
import Lens.Final.Tuple2 as Tuple2


-- can't use Util.negateVia because of occasional need to test with `isErr`
negatory lens = Lens.update lens negate 

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
    lens = Array.pathLens 1
    underlyingSetter = Array.set 1
  in
    describe "array lenses obey the path lens laws"
      [ present lens underlyingSetter (array [3, original])

      , missing lens                  Array.empty   "too short"
      ]

dict_laws : Test
dict_laws = 
  let
    lens = Dict.pathLens "key"
    underlyingSetter = Dict.insert "key"
  in
    describe "dict lenses obey the path lens laws"
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
    at0 = Array.pathLens 0
    at1 = Array.pathLens 1

    dictLens = Dict.pathLens "key"
  in
    describe "update for various common base types (path lenses)"
      [ equal_ (negatory at0 <| array [3])     (Ok <| array [-3])
      , is_    (negatory at0 <| Array.empty)   Result.isErr
      , is_    (negatory at1 <| array [3])     Result.isErr
        
      , equal_ (negatory dictLens <| dict "key" 3)   (Ok <| dict "key" -3)
      , is_    (negatory dictLens <| dict "---" 3)   Result.isErr
      , is_    (negatory dictLens <| Dict.empty)     Result.isErr
      ]

{- 
    set and update produce error lists
-}

set_failure : Test
set_failure =
  let
    lens = Dict.pathLens "key"
    whole = dict "not key" 3
    expected = { whole = whole , path = ["`\"key\"`"] }
  in
    describe "set produces error lists"
      [ equal_ (Lens.set lens 33 whole) (Err expected)
      ]

update_failure : Test
update_failure =
  let
    lens = Array.pathLens 3
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
      [ exists (Dict.pathLens "key")    Dict.empty       False
      , exists (Dict.pathLens "key")    (dict "---" 3)   False
      , exists (Dict.pathLens "key")    (dict "key" 3)   True
      ]
      
{-
      Converting other lenses into this type of lens
 -}

classicToPath : Test
classicToPath = 
  let
    lens = Compose.classicToPath "tuple-second" Tuple2.second
    underlyingSetter new (first, second) = (first, new)

    extractPath (Tagged lens) = lens.path
  in
    describe "classic to path" -- note that `Err` cases are impossible.
      [ present lens underlyingSetter    (88.8, original)

      , equal_ (negatory lens (88.8, original))   (Ok (88.8, negate original))

      , equal (extractPath lens) ["`\"tuple-second\"`"]  "stored for use in composition"
      ]

humbleToPath : Test
humbleToPath =
  let
    lens = Compose.humbleToPath 88 <| Dict.humbleLens "key"
    path = ["`88`"]

    get whole = equal_ (Lens.get lens whole)
    set new whole = equal_ (Lens.set lens new whole)
    update whole = equal_ (Lens.update lens negate whole)
    pathExists whole expected comment =
      equal (Lens.pathExists lens whole) expected comment

  in
    describe "humble to path"
      [ describe "get"
          [
            get (dict "key" 5)   (Ok 5)
          , get (dict "---" 4)   (Err {whole = (dict "---" 4), path = path})
          , get Dict.empty       (Err {whole = Dict.empty, path = path})
          ]
      , describe "set"
          [
            set 55 (dict "key" 5)  (Ok <| dict "key" 55)
          , set 55 (dict "---" 4)  (Err {whole = dict "---" 4, path = path})
          ]

      , describe "update"
          [
            update (dict "key" 5)  (Ok <| dict "key" -5)
          , update (dict "---" 4)  (Err {whole = dict "---" 4, path = path})
          ]
      , describe "pathExists"
          [
            pathExists (dict "key" 5)  True    "success"
          , pathExists (dict "---" 4)  False   "bad key"
          ]

      , (let
           certainGet =
             Dict.get "key" >> Maybe.withDefault 99.99
           underlyingSetter =
             Dict.insert "key"
         in
           describe "composed paths obey the path lens laws" 
             [ present lens underlyingSetter (dict "key" original)
               
             , missing lens                  Dict.empty    "no key"
             ])
      ]
               

{- 
      Composing lenses to PRODUCE this type of lens
-}

pathAndPath : Test
pathAndPath =
  let
    lens = Compose.pathAndPath (Dict.pathLens "key") (Array.pathLens 0)

    get whole = equal_ (Lens.get lens whole)
    set new whole = equal_ (Lens.set lens new whole)
    update whole = equal_ (Lens.update lens negate whole)
    pathExists whole expected comment =
      equal (Lens.pathExists lens whole) expected comment

    w key list = dict key (array list)
    dictValuePath =  ["`\"key\"`"]
    arrayValuePath = ["`\"key\"`", "`0`"]

  in
    describe "path and path"
      [ describe "get"
          [
            get (w "key" [5])   (Ok 5)
          , get (w "---" [4])   (Err {whole = w "---" [4], path = dictValuePath})
          , get (w "key" [ ])   (Err {whole = w "key" [ ], path = arrayValuePath})
          ]
      , describe "set"
          [
            set 55 (w "key" [5])  (Ok <| w "key" [55])
          , set 55 (w "---" [4])  (Err {whole = w "---" [4], path = dictValuePath})
          , set 55 (w "key" [ ])  (Err {whole = w "key" [ ], path = arrayValuePath})
          ]

      , describe "update"
          [
            update (w "key" [5])  (Ok <| w "key" [-5])
          , update (w "---" [4])  (Err {whole = w "---" [4], path = dictValuePath})
          , update (w "key" [ ])  (Err {whole = w "key" [ ], path = arrayValuePath})
          ]
      , describe "pathExists"
          [
            pathExists (w "key" [5])  True    "success"
          , pathExists (w "---" [4])  False   "bad key"
          , pathExists (w "key" [ ])  False   "bad index"
          ]

      , (let
           certainGet =
             Dict.get "key" >> Maybe.withDefault Array.empty
           underlyingSetter new whole =
             Dict.insert "key" (Array.set 0 new <| certainGet whole) whole
         in
           describe "composed paths obey the path lens laws" 
             [ present lens underlyingSetter (w "key" [original, 5])
               
             , missing lens                  (w "key" [           ])   "too short"
             , missing lens                  (w "---" [original, 5])   "bad key"
             ])
      ]


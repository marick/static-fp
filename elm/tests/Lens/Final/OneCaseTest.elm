module Lens.Final.OneCaseTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util as Util exposing (negateVia, dict, array)
import Tagged exposing (Tagged(..))
import Lens.Final.ClassicTest as ClassicTest

import Lens.Final.Lens as Lens
import Lens.Final.Compose as Compose

import Lens.Final.Result as Result
import Lens.Final.Maybe as Maybe





{- 
     The laws for this lens type 
 -}

get_set (Tagged {get, set}) whole part =
  describe "retrieving a part, then setting it back"
    [ -- describe required context
      equal  (get whole)    (Just part)   "get succeeds"
        
    , equal  (set part)     whole         "law is upheld"
    ]

set_get (Tagged {get, set}) whole part =
  describe "when a part is present, `set` overwrites it"
    [ -- describe required context
      equal       (set part)     whole          "whole is created by setting part"

    , equal  (get (set part))    (Just part)    "law is upheld"
    ]


makeLawTest arbitraryWrappedValue lens constructor comment =
  describe comment
    [ get_set lens (constructor arbitraryWrappedValue) arbitraryWrappedValue
    , set_get lens (constructor arbitraryWrappedValue) arbitraryWrappedValue
    ]

-- The most common way to use law tests
legal =
  makeLawTest "arbitrary value"


{-
     The various predefined types obey the LAWS
 -}

lawTest : Test
lawTest =
  describe "oneCase lenses obey the oneCase lens laws"
    [ legal Result.okLens   Ok      "ok lens"
    , legal Result.errLens  Err     "err lens"
      
    , legal Maybe.justLens  Just    "just lens"
    ]

    
{-
         Check that `update` works correctly for each type.
         (Overkill, really, since every type uses the same `update` code,
         which depends only on the correctness of `get` and `set`.)
 -}

update : Test
update =
  describe "update for various common base types (one-case lenses)"
    [ negateVia Result.okLens (Ok  3)  (Ok  -3)
    , negateVia Result.okLens (Err 3)  (Err  3)

    , negateVia Result.errLens (Ok  3) (Ok   3)
    , negateVia Result.errLens (Err 3) (Err -3)

    , negateVia Maybe.justLens (Just 3)  (Just  -3)
    , negateVia Maybe.justLens Nothing   Nothing
    ]
  

{-
    Functions beyond the stock get/set/update
 -}


exists : Test
exists =
  let
    exists lens whole expected = 
      equal (Lens.exists lens whole) expected (toString whole)
  in
    describe "exists"
      [ exists Result.okLens    (Ok 3)      True
      , exists Result.okLens    (Err '-')   False
      , exists Result.errLens   (Err '!')   True
      ]

getWithDefault : Test
getWithDefault =
  let
    get lens whole expected = 
      equal (Lens.getWithDefault lens "default" whole) expected (toString whole)
  in
    describe "getWithDefault"
      [ get Maybe.justLens (Just "here")     (Just "here")
      , get Maybe.justLens Nothing           (Just "default")
      ]
      
{-
      Converting other lenses into this type of lens
 -}

-- None        

{- 
      Composing lenses to PRODUCE this type of lens
-}


-- None

module Lens.Try3.OneCaseTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (negateVia, dict, array)
import Tagged exposing (Tagged(..))
import Lens.Try3.ClassicTest as ClassicTest

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose

import Lens.Try3.Result as Result
import Lens.Try3.Maybe as Maybe





{- 
     The laws for this lens type 
 -}

laws arbitraryWrappedValue lens constructor comment =
  describe comment
    [ get_set lens (constructor arbitraryWrappedValue) arbitraryWrappedValue
    , set_get lens (constructor arbitraryWrappedValue) arbitraryWrappedValue
    ]


-- Even where the laws have the same meaning as for the classic lens, the type
-- signatures are too different to reuse them.

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



{-
     The various predefined types obey the LAWS
 -}

lawTest : Test
lawTest =
  let
    legal = laws (1, 2)
  in
    describe "oneCase lenses obey the oneCase lens laws"
      [ legal Result.ok   Ok      "ok lens"
      , legal Result.err  Err     "err lens"

      , legal Maybe.just  Just    "just lens"
      ]

    
{-
         Check that `update` works correctly for each type.
         (Overkill, really, since every type uses the same `update` code,
         which depends only on the correctness of `get` and `set`.)
 -}

update : Test
update =
  describe "update for various common base types (one-case lenses)"
    [ negateVia Result.ok (Ok  3)  (Ok  -3)
    , negateVia Result.ok (Err 3)  (Err  3)

    , negateVia Result.err (Ok  3) (Ok   3)
    , negateVia Result.err (Err 3) (Err -3)

    , negateVia Maybe.just (Just 3)  (Just  -3)
    , negateVia Maybe.just Nothing   Nothing
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
      [ exists Result.ok    (Ok 3)      True
      , exists Result.ok    (Err '-')   False
      , exists Result.err   (Err '!')   True
      ]

getWithDefault : Test
getWithDefault =
  let
    get lens whole expected = 
      equal (Lens.getWithDefault lens "default" whole) expected (toString whole)
  in
    describe "getWithDefault"
      [ get Maybe.just (Just "here")     (Just "here")
      , get Maybe.just Nothing           (Just "default")
      ]
      
{-
      Converting other lenses into this type of lens
 -}

-- None        

{- 
      Composing lenses to PRODUCE this type of lens
-}


-- None

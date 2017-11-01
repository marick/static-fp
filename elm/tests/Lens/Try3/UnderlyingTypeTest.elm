module Lens.Try3.UnderlyingTypeTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Util as Util exposing (..)
import Dict
import Array

import Lens.Try3.Lens as Lens
import Lens.Try3.Laws as Laws

import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Tuple3 as Tuple3
import Lens.Try3.Tuple4 as Tuple4
import Lens.Try3.Dict as Dict
import Lens.Try3.Array as Array
import Lens.Try3.Result as Result
import Lens.Try3.Maybe as Maybe




{-         Types used to construct CLASSIC lenses        -}

-- Records are classic lenses

type alias Record a =
  { part : a
  }

record = Lens.classic .part (\part whole -> { whole | part = part })


classicUpdate : Test
classicUpdate =
  describe "update for various common base types (classic lenses)"
    [ upt record         {part = 3}        {part = -3}
        
    , upt Tuple2.first   (3, "")           (-3, "")
    , upt Tuple2.second  ("", 3)           ("", -3)
      
    , upt Tuple3.first   (3, "", "")       (-3, "", "")
    , upt Tuple3.second  ("", 3, "")       ("", -3, "")
    , upt Tuple3.third   ("", "", 3)       ("", "", -3)
      
    , upt Tuple4.first   (3, "", "", "")   (-3, "", "", "")
    , upt Tuple4.second  ("", 3, "", "")   ("", -3, "", "")
    , upt Tuple4.third   ("", "", 3, "")   ("", "", -3, "")
    , upt Tuple4.fourth  ("", "", "", 3)   ("", "", "", -3)
    ]
  
classicLaws : Test
classicLaws =
  let
    (original, legal) = classicLawSupport
  in
    describe "classic lens laws for various base types"
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

      
{-         Types used to construct UPSERT lenses        -}

upsertUpdate : Test
upsertUpdate =
  describe "update for various common base types (upsert lenses)"
    [ upt (Dict.lens "key") (Dict.singleton "key" 3) (Dict.singleton "key" -3)
    , upt (Dict.lens "key") (Dict.singleton "k  " 3) (Dict.singleton "k  "  3)
    , upt (Dict.lens "key")  Dict.empty               Dict.empty
    ]

laws : Test
laws =
  describe "classic laws apply to Dict lenses" <|
    List.map 
      (Util.upsertLensObeysClassicLaws
         { lens = Dict.lens "key"
         , focusMissing = Dict.empty
         , makeFocus = Dict.singleton "key"
         })
      (Util.maybeCombinations "OLD" "overwritten" "NEW")


{-         Types used to construct HUMBLE lenses        -}

humbleUpdate : Test
humbleUpdate =
  let
    at0 = Array.lens 0
    at1 = Array.lens 1

    dictLens = Dict.humbleLens "key"
    d = Dict.singleton 
  in
    describe "update for various common base types (humble lenses)"
      [ upt at0 (Array.fromList [3]) (Array.fromList [-3])
      , upt at1 (Array.fromList [3]) (Array.fromList [ 3])
      , upt at1  Array.empty          Array.empty
        
      , upt dictLens (d "key" 3)   (d "key" -3)
      , upt dictLens (d "---" 3)   (d "---"  3)
      , upt dictLens Dict.empty    Dict.empty
      ]

      
humbleLaws : Test
humbleLaws =
  let
    (original, present, missing) = humbleLawSupport
  in
    describe "humble lenses obey the humble lens laws"
      [ present (Array.lens 1)   (Array.fromList [' ', original])
      , missing (Array.lens 1)   (Array.fromList [' '          ])   "short"
      ]

{-         Types used to construct OneCase lenses        -}

oneCaseUpdate : Test
oneCaseUpdate =
  describe "update for various common base types (one-case lenses)"
    [ upt Result.ok (Ok  3)  (Ok  -3)
    , upt Result.ok (Err 3)  (Err  3)

    , upt Result.err (Ok  3) (Ok   3)
    , upt Result.err (Err 3) (Err -3)

    , upt Maybe.just (Just 3)  (Just  -3)
    , upt Maybe.just Nothing   Nothing
    ]

      
oneCaseLaws : Test
oneCaseLaws =
  let
    legal = Laws.onePart
  in
    describe "oneCase lenses obey the oneCase lens laws"
      [ legal Result.ok   Ok      "ok lens"
      , legal Result.err  Err     "err lens"

      , legal Maybe.just  Just    "just lens"
      ]


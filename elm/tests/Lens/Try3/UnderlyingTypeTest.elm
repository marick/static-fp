module Lens.Try3.UnderlyingTypeTest exposing (..)

import Lens.Try3.Lens as Lens exposing (ClassicLens, get, set, update)
import Lens.Try3.Tuple2 as Tuple2
import Lens.Try3.Tuple3 as Tuple3
import Lens.Try3.Tuple4 as Tuple4
import Dict
import Lens.Try3.Dict as Dict
import Array
import Lens.Try3.Array as Array

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Try3.Laws as Laws
import Lens.Try3.Util exposing (..)




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
    (original, parts, legal) = classicLawSupport
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
    [ upt (Dict.lens "key") (Dict.singleton "key" 3) <| Dict.singleton "key" -3
    , upt (Dict.lens "key") (Dict.singleton "k  " 3) (Dict.singleton "k  "  3)          
    , upt (Dict.lens "key")  Dict.empty               Dict.empty
    ]

upsertLaws : Test
upsertLaws =
  let
    (original, parts, legal) = upsertLawSupport
  in
    describe "upsert lenses obey the classic lens laws"
      [ describe "dict"
          [ legal (Dict.lens "key") (Dict.singleton "key" original)
          , legal (Dict.lens "key") (Dict.singleton "---" original)
          ]
      ]


{-         Types used to construct IFFY lenses        -}

iffyUpdate : Test
iffyUpdate =
  describe "update for various common base types (iffy lenses)"
    [ upt (Array.lens 0) (Array.fromList [3]) (Array.fromList [-3])
    , upt (Array.lens 1) (Array.fromList [3]) (Array.fromList [ 3])
    , upt (Array.lens 1)  Array.empty          Array.empty
    ]

      
iffyLaws : Test
iffyLaws =
  let
    (original, parts, present, missing) = iffyLawSupport
  in
    describe "iffy lenses obey the iffy lens laws"
      [ present (Array.lens 1)   (Array.fromList [' ', original])
      , missing (Array.lens 1)   (Array.fromList [original])         "short"
      ]


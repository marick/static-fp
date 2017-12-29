module Lens.Final.MonoidTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Lens.Final.Util exposing (..)
import Dict
import Array
import Lens.Final.Tuple2 as Tuple2
import Lens.Final.Tuple3 as Tuple3
import Lens.Final.Array as Array

import Lens.Final.Lens as Lens 
import Lens.Final.Compose as Lens
import Lens.Final.Operators exposing (..)


equal_lenses first second whole part comment = 
  describe comment
    [ equal_ (Lens.get first      whole)   (Lens.get second      whole)
    , equal_ (Lens.set first part whole)   (Lens.set second part whole)
    ]

classic : Test
classic =
  let
    id = Lens.classicIdentity
    
    left = (Tuple3.second ..>> Tuple3.third) ..>> Tuple3.first
    right = Tuple3.second ..>> (Tuple3.third ..>> Tuple3.first)
  in
    describe "a classic lens is a monoid" 
      [ equal_lenses (id ..>> Tuple2.second) Tuple2.second (1, 2) 3  "left id"
      , equal_lenses (Tuple2.second ..>> id) Tuple2.second (1, 2) 3  "right id"

      , equal_lenses left right (1, (21, 22, (31, 32, 33)), 3)   8 "associativity"
      ]                                                                    

humble : Test
humble =
  let
    id = Lens.humbleIdentity
    
    left = (Array.lens 1 ??>>  Array.lens 2) ??>> Array.lens 0 
    right = Array.lens 1 ??>> (Array.lens 2  ??>> Array.lens 0)

    a = Array.fromList 

    nested = a[ a[]
              , a[ a[2]   --<- target
                 , a[3]
                 , a[4]
                 ]
              ]
  in
    describe "a humble lens is a monoid" 
      [ equal_lenses (id ??>> Array.lens 1) (Array.lens 1)
          (Array.fromList [3, 6]) 8                             "left id"
      , equal_lenses (Array.lens 0 ??>> id) (Array.lens 0)
          (Array.fromList ["1", "2"]) "3"                       "right id"

      , equal_lenses left right nested  8                       "associativity"
      ]                                                                    
      

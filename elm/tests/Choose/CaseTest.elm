module Choose.CaseTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (..)
import Choose.Case as Prism
import Choose.Operators exposing (..)
import Maybe.Extra as Maybe
import Result
import Choose.Definitions as D

import Dict exposing (Dict)


---------- Basics

operations : Test
operations =
  let
    (get, set, update) = accessors D.id -- id is Prism for (Id Int)
  in
    describe "operations"
      [ equal_    (get <| D.Id 3)          (Just 3)
      , equal_    (get <| D.Name "fred")   Nothing

      , equal     (set 0)      (D.Id 0)                              "always succeeds"

      , equal_    (update negate (D.Id 8))             (D.Id -8)
      , equal     (update negate (D.Name "fred"))   (D.Name "fred")  "no change"
      ]


---------- Laws

-- Laws don't lend themselves to clear the generalized `lawTests` of
-- other modules. So here's a simple example:

lawTests prism original tag =
  let 
    (get, set, _) = accessors prism
  in
    describe tag
      [ -- Law 1: You get back what you create
        equal_ (get (set "new"))  (Just "new")

        -- Law 2: If you set what you got out, you have the original value.
        -- IF get value == Just tuple THEN set tuple == value
      , equal (get original)   (Just "focus")    "for reference: what's gotten"
      , equal (set "focus")    original          "setter fully constructs"
      ]

laws =
  describe "laws for prisms (Case)"
    [ lawTests D.name (D.Name "focus")                  "Simple sum types"
    , lawTests (D.chooseTwo >..> D.chooseOk)
               (D.Two <| Ok "focus")                    "composition"
    ]
      
---------- Composition
-- It's worth spelling out the consequences of composition.
      
composition =
  let
    (get, set, update) = accessors (D.chooseOne >..> D.chooseOk)
  in
    describe "composition"
      [ describe "get"
          [ nothing (get (D.Two <| Err ""))    "both wrong"
          , nothing (get (D.Two <| Ok ""))     "Looking for One"
          , nothing (get (D.One <| Err ""))    "Looking for Ok"
          , eql     (get (D.One <| Ok 3))      (Just 3)
          ]
      , describe "set"
          [ eql (set 8) (D.One <| Ok 8) ]
      , describe "update"
        [ unchanged_ (update negate) (D.Two <| Err "f")
        , unchanged_ (update negate) (D.Two <| Ok "f")
        , unchanged_ (update negate) (D.One <| Err "f")
        , eql        (update negate  (D.One <| Ok 3))     (D.One <| Ok -3)
        ]
      ]


-- Util

accessors chooser =
  ( Prism.get chooser
  , Prism.set chooser
  , Prism.update chooser
  )



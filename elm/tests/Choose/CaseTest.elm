module Choose.CaseTest exposing (..)

import Test exposing (..)
import TestBuilders exposing (nothing, just, justo, eql, equal)
import Choose.Case as Case
import Maybe.Extra as Maybe
import Result

import Dict exposing (Dict)

type Identifier
  = Id Int
  | Name String


id = Case.make
     (\ whole ->
        case whole of
          Id id -> Just id
          _ -> Nothing)
       
     Id
       
name = Case.make
       (\ whole ->
          case whole of
            Name name -> Just name
            _ -> Nothing)

       Name

getting =
  let
    get = Case.get 
  in
    describe "getting" 
      [ justo (get id   <| Id 3       )  3
      , justo (get name <| Name "fred")  "fred"
                
      , nothing (get id <| Name "fred")          "case - value mismatch"
      ]
       
setting =
  let
    set = Case.set
  in
    describe "setting" 
      [ eql (set id 8)          (Id 8)
      , eql (set name "fred")   (Name "fred")
      ]

update =
  let
    update = Case.update
  in
    describe "update" 
      [ eql   (update id negate (Id 8))          (Id -8)
      , equal (update id negate (Name "fred"))   (Name "fred")  "irrelevant - no change"
      ]


-- Composition

      
type Outer
  = One (Result String Int)
  | Two (Result String Float)

two = Case.make
      (\ big -> 
         case big of
           Two little -> Just little
           _ -> Nothing)
      Two


ok = Case.make Result.toMaybe Ok


innerFloat = two |> Case.next ok

composition =
  let
    get = Case.get innerFloat
    update = Case.update innerFloat
    set = Case.set innerFloat
    unchanged f original =
      eql (f original) original
  in
    describe "composition"
      [ describe "get"
          [ nothing (get (One <| Err "foo")) "both wrong"
          , nothing (get (One <| Ok 1))      "Looking for Two"
          , nothing (get (Two <| Err "foo")) "Looking for Ok"
          , eql     (get (Two <| Ok 3.4))      (Just 3.4)
          ]
      , describe "set"
          [ eql (set 8.4) (Two <| Ok 8.4) ]
      , describe "update"
        [ unchanged (update negate) (One <| Err "foo")
        , unchanged (update negate) (One <| Ok 1)
        , unchanged (update negate) (Two <| Err "foo")
        , eql       (update negate (Two <| Ok 3.4))     (Two <| Ok -3.4)
        ]
      ]

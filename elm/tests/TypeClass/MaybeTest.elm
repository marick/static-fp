module TypeClass.MaybeTest exposing (..)

import Test exposing (..)
import TestBuilders as Build exposing (equal_)

import TypeClass.Maybe as Maybe

{- Maybe as a Functor -}

functor_identity : Test
functor_identity = 
  describe "functor identity"
    [ equal_ (Maybe.map identity <| Just 3) (Just 3)
    , equal_ (Maybe.map identity Nothing)    Nothing
    ]

functor_composition : Test
functor_composition =
  let 
    left = Maybe.map (negate >> round)
    right = Maybe.map negate >> Maybe.map round
  in
    describe "functor composition"
      [ equal_ (left <| Just 1.1)    (right <| Just 1.1)
      , equal_ (left <| Just 8.8)    (right <| Just 8.8)
      , equal_ (left Nothing)        (right Nothing)
      ]

{- Two monoid interpretations of `Maybe`-}

monoid_append_left : Test
monoid_append_left =
  let
    try = Build.f_2_expected_comment Maybe.append_left
  in
    describe "append_left law for one monoid interpretation of Maybe"
      [ try (Just 1,  Just 2)     (Just 1)     "left takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]

monoid_append_right : Test
monoid_append_right =
  let
    try = Build.f_2_expected_comment Maybe.append_right
  in
    describe "append_right law for another interpretation of Maybe"
      [ try (Just 1,  Just 2)     (Just 2)     "right takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]



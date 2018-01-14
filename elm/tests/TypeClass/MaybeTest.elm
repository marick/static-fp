module TypeClass.MaybeTest exposing (..)

import Test exposing (..)
import TestBuilders as Build 

import TypeClass.Maybe as Maybe

append_left : Test
append_left =
  let
    try = Build.f_2_expected_comment Maybe.append_left
  in
    describe "append_left law for one monoid interpretation of Maybe"
      [ try (Just 1,  Just 2)     (Just 1)     "left takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]

append_right : Test
append_right =
  let
    try = Build.f_2_expected_comment Maybe.append_right
  in
    describe "append_right law for another interpretation of Maybe"
      [ try (Just 1,  Just 2)     (Just 2)     "right takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]

module Monoid.MaybeTest exposing (..)

import Test exposing (..)
import TestBuilders as Build 

import Monoid.Maybe as Maybe

append_left =
  let
    try = Build.f_2_expected_comment Maybe.append_left
  in
    describe "append_left"
      [ try (Just 1,  Just 2)     (Just 1)     "left takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]


append_right =
  let
    try = Build.f_2_expected_comment Maybe.append_right
  in
    describe "append_right"
      [ try (Just 1,  Just 2)     (Just 2)     "right takes precedence"
      , try (Nothing, Just 2)     (Just 2)     "no left"
      , try (Just 1,  Nothing)    (Just 1)     "only left"
      , try (Nothing, Nothing)    Nothing      "neither"
      ]

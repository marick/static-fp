module Intro.First where

import Prelude
import Data.Map (Map)
import Data.Map as Map

import Data.Tuple
import Data.List (List)

someMap :: Map String Int
someMap = Map.singleton "a" 1

increment :: Int -> Int
increment i = i + 1

keysAndValues :: forall key val .
                 Map key val -> Tuple (List key) (List val)
keysAndValues kvs =
  Tuple (Map.keys kvs) (Map.values kvs)



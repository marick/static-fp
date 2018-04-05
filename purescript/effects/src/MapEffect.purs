module MapEffect where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Random
import Control.Apply
import Data.Tuple

randomTuple :: Eff _ (Tuple Int Int)
randomTuple = lift2 Tuple (randomInt 1 10) (randomInt 100 10000)

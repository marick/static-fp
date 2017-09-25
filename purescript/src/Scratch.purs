module Scratch where

import Prelude
import Control.Monad.Eff.Random
import Control.Monad.Eff.Console

func arg = do
  there <- random
  let here = 500.0
  logShow (here + there + arg)

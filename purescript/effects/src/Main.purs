module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import Control.Monad.Eff.Random

main :: forall e. Eff _ Unit
main = do
  randomInt 0 400 >>= logShow 

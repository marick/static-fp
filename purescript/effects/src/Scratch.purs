module Scratch where

{-
    You can paste all of these imports into the repl.
    To keep `pulp build` from whining, the equivalents
    outside this comment use explicit imports

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random
import Control.Monad.Eff.Console
import Control.Apply
import Control.Bind
import Data.Tuple

-}

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (randomInt)
import Control.Monad.Eff.Console (logShow)
import Control.Apply (lift2)
import Control.Bind (bindFlipped)
import Data.Tuple (Tuple(..), fst)


{- Creating an effect to produce a tuple of random numbers. -}

randomTuple :: Eff _ (Tuple Int Int)
randomTuple = lift2 Tuple (randomInt 1 10) (randomInt 100 10000)


{- Logging the result of an effect to the console -} 

logRandom :: Eff _ Unit
logRandom = 
  randomTuple
    # map fst
    # bindFlipped logShow


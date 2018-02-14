module Random where

import Prelude

import Data.Array
import Data.Maybe
import Data.Tuple

import Control.Monad.Eff.Random
import Control.Monad.Eff.Now
import Control.Monad.Eff.Console
import Control.Apply
import Data.Int


{-

(apply (map Tuple random) random)
Tuple <$> random <*> random



-}

doit true = log "even"
doit false = log "even"

sign n = 
  case even n of
    true -> "even"
    false -> "odd"

-- randomInt 1 3 <#> sign) >>= log

doish = 
  do
    n <- randomInt 1 5
    let output = sign n
    log output

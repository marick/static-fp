module MapEffectSolution where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (randomInt)
import Control.Apply (lift2)
import Data.Tuple (Tuple(..), snd, uncurry)

randomTuple :: Eff _ (Tuple Int Int)
randomTuple = lift2 Tuple (randomInt 1 10) (randomInt 100 10000)

{-     Part 1   -}

negatedSnd :: Eff _ Int
negatedSnd = randomTuple # map snd # map negate


{-     Part 2   -}

summed :: Eff _ Int
summed =
  let
    sumTuple (Tuple a b) = a + b
  in
    randomTuple # map sumTuple

-- Alternately, you may remember that Elm's `uncurry` turns a function
-- that takes two arguments into one that takes a tuple. PureScript has
-- the same function, so:

summed2 :: Eff _ Int
summed2 = randomTuple # map (uncurry (+))

-- Pipelining is not greatly idiomatic in PureScript. In this case,
-- that results in something that's perhaps more readable:

summed3 :: Eff _ Int
summed3 = map (uncurry (+)) randomTuple


{-     Part 3   -}

bySeven :: Eff _ Boolean
bySeven =
  let
    divisible n =
      mod n 7 == 0
  in
   randomInt 0 100 # map divisible



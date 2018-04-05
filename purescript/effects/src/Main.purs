module Main where

{-
   This is an example of a program you can run from the command line.
   Do this:

      pulp run
-}

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (logShow)
import Control.Monad.Eff.Random (randomInt)

{-
   Note: if you see warnings like this when working with `pulp build` or
   `pulp run`, ignore them.

      19  main :: Eff _ Unit
                      ^
      
      Wildcard type definition has the inferred type
      
        ( random :: RANDOM
        , console :: CONSOLE
        | t0
        )

   It wants us to be more specific than the wildcard `_`. But we're looking
   ahead to a later version of PureScript.

-}

main :: Eff _ Unit
main = do
  randomInt 0 400 >>= logShow 

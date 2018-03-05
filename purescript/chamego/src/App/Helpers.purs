module App.Helpers
 (generateRandoSequence
 ) where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (RANDOM, randomInt)
import Data.List (List)
import Data.Unfoldable (replicateA)

generateRandoSequence :: ∀ eff. Eff (random :: RANDOM | eff) (List String)
generateRandoSequence =
  map (\v ->
    case v of
      1 -> "red"
      2 -> "yellow"
      3 -> "green"
      4 -> "blue"
      _ -> "Oh nose 👃"
  ) <$> replicateA 20 (randomInt 1 4)

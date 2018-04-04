module Word where

import Prelude
import Data.Lens

type Word =
  { count :: Int
  , text :: String
  }

new :: String -> Word    
new text =
  { count : 1 , text : text }

like :: Word -> Word
like word@{count} = word { count = count + 1}

{- Lenses -}

count :: Lens' Word Int
count = lens _.count $ _ { count = _}

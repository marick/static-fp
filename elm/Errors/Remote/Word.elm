module Errors.Simple.Word exposing (..)

import Errors.Simple.Basics exposing (increment)
import Lens.Final.Lens as Lens 

{- Word -}

type alias Word =
  { count : Int
  , text : String
  }

like : Word -> Word
like word =
  Lens.update count increment word

new : String -> Word    
new text =
  { count = 1 , text = text }

{- Lenses -}      

count : Lens.Classic Word Int
count =
  Lens.classic .count (\count model -> { model | count = count })

      

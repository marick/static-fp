module Errors.Simple.Word exposing (..)

import Errors.Simple.Basics exposing (increment)
import Lens.Try4.Lens as Lens 

{- Word -}

type alias Word =
  { count : Int
  , text : String
  }

emphasize : Word -> Word
emphasize word =
  Lens.update count increment word

all : List Word    
all =
  let
    start text =
      { count = 1 , text = text }
  in
    List.map start ["cafuné", "chamego", "amor da minha vida"]

{- Lenses -}      

count : Lens.Classic Word Int
count =
  Lens.classic .count (\count model -> { model | count = count })

      

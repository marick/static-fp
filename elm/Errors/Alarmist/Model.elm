module Errors.Alarmist.Model exposing
  ( Model
  , init

  , clickCount
  , beloved
  , word
  , wordCount
  )

import Errors.Simple.Word as Word exposing (Word)

import Lens.Final.Lens as Lens
import Lens.Final.Operators exposing (..)
import Lens.Final.Compose as Compose
import Dict exposing (Dict)
import Array exposing (Array)
import Lens.Final.Dict as Dict
import Lens.Final.Array as Array


{- Model -}
    
type alias Model =
  { words : Dict String (Array Word)
  , beloved : String
  , clickCount : Int
  }

  
init : (Model, Cmd msg)
init =
  ( { words = Dict.singleton "Dawn" (Array.fromList Word.all)
    , beloved = "Dawn"
    , clickCount = 0
    }
  , Cmd.none
  )


{- Lenses -}

clickCount : Lens.Classic Model Int
clickCount =
  Lens.classic .clickCount (\clickCount model -> { model | clickCount = clickCount })

beloved : Lens.Classic Model String
beloved =
  Lens.classic .beloved (\beloved model -> { model | beloved = beloved })
    
words : Lens.Classic Model (Dict String (Array Word))
words =
  Lens.classic .words (\words model -> { model | words = words })

word : String -> Int -> Lens.Path Model Word
word who index =
  Compose.classicToPath ".words" words
    !!>> Dict.pathLens who
    !!>> Array.pathLens index

wordCount : String -> Int -> Lens.Path Model Int
wordCount who index =
  word who index !!>> Compose.classicToPath ".count" Word.count

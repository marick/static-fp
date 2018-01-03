module Errors.Simple.UpdateActions exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Simple.Model as Model exposing (Model, Name)

import Lens.Final.Lens as Lens 
import Date exposing (Date)

{- Functions used in the first version (Main) -}


incrementClickCount : Model -> Model
incrementClickCount = 
  Lens.update Model.clickCount increment

incrementWordCount : Name -> Int -> Model -> Model
incrementWordCount person index = 
  Lens.update (Model.wordCount person index) increment

focusOn : Name -> Model -> Model
focusOn person = 
  Lens.set Model.focusPerson person 

noteDate : Date -> Model -> Model
noteDate date = 
  Lens.set Model.lastChange (Just date)


{- Functions used in the second version (Main2) -}

isExistingWord : Name -> Int -> Model -> Bool
isExistingWord person index = 
  Lens.exists <| Model.word person index

isExistingPerson : Name -> Model -> Bool
isExistingPerson person = 
  Lens.exists <| Model.personWords person


{- Functions used in the third version (Main3) -}

incrementWordCountM : Name -> Int -> Model -> Maybe Model
incrementWordCountM person index = 
  Lens.updateM (Model.wordCount person index) increment

focusOnM : Name -> Model -> Maybe Model
focusOnM person model =
  case Lens.exists (Model.personWords person) model of
    True -> Just (Lens.set Model.focusPerson person model)
    False -> Nothing
    

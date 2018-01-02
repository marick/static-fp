module Errors.Simple.UpdateActions exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Simple.Model as Model exposing (Model)

import Lens.Final.Lens as Lens 
import Date exposing (Date)

{- Actions -}

incrementClickCount : Model -> Model
incrementClickCount = 
  Lens.update Model.clickCount increment

incrementWordCount : String -> Int -> Model -> Model
incrementWordCount person index = 
  Lens.update (Model.wordCount person index) increment

incrementWordCountM : String -> Int -> Model -> Maybe Model
incrementWordCountM person index = 
  Lens.updateM (Model.wordCount person index) increment

focusOn : String -> Model -> Model
focusOn person = 
  Lens.set Model.focusPerson person 

focusOnM : String -> Model -> Maybe Model
focusOnM person model =
  case Lens.exists (Model.personWords person) model of
    True -> Just (Lens.set Model.focusPerson person model)
    False -> Nothing

noteDate : Date -> Model -> Model
noteDate date = 
  Lens.set Model.lastChange (Just date)

{- validations -}
    
isExistingWord : String -> Int -> Model -> Bool
isExistingWord person index = 
  Lens.exists <| Model.word person index

isExistingPerson : String -> Model -> Bool
isExistingPerson person = 
  Lens.exists <| Model.personWords person


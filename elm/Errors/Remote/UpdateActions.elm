module Errors.Remote.UpdateActions exposing (..)

import Errors.Remote.Basics exposing (..)
import Errors.Remote.Msg as Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model, Name, Index)
import Errors.Remote.Errors as Error exposing (Error)

import Lens.Final.Lens as Lens 
import Date exposing (Date)
import Task

{- Actions -}


incrementClickCount : Model -> Model
incrementClickCount = 
  Lens.update Model.clickCount increment

incrementWordCount : Name -> Index -> Model -> Result Error Model 
incrementWordCount person index model =
  model 
    |> Lens.update (Model.wordCount person index) increment
    |> Result.mapError Error.MissingWord

focusOn : Name -> Model -> Result Error Model
focusOn person model =
  case Lens.get (Model.personWords person) model of
    Ok _ -> Ok <| Lens.set Model.focusPerson person model
    Err err -> Err <| Error.MissingWord err

noteDate : Date -> Model -> Model
noteDate date = 
  Lens.set Model.lastChange (Just date)


{- Commands -}

fetchDateCmd : Cmd Msg
fetchDateCmd = 
  Task.perform LastChange Date.now

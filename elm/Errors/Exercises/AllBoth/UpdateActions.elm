module Errors.Exercises.AllBoth.UpdateActions exposing (..)

import Errors.Exercises.AllBoth.Flow as Flow
import Errors.Remote.Basics exposing (..)
import Errors.Remote.Msg as Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model, Name, Index)
import Errors.Remote.Errors as Error exposing (Error)

import Lens.Final.Lens as Lens 
import Date exposing (Date)
import Task


{- Actions -}

incrementClickCount : Model -> Flow.ActionSuccess
incrementClickCount = 
  Lens.update Model.clickCount increment >> Flow.Only

incrementWordCount : Name -> Index -> Model -> Flow.ActionResult
incrementWordCount person index model =
  case Lens.update (Model.wordCount person index) increment model of
    Ok model ->
      success2 model <| fetchDateCmd index
    Err err ->
      oops Error.MissingWord err

focusOn : Name -> Model -> Flow.ActionResult
focusOn person model =
  case Lens.get (Model.personWords person) model of
    Ok _ ->
      success1 <| Lens.set Model.focusPerson person model
    Err err ->
      oops Error.MissingWord err

noteDate : Date -> Model -> Flow.ActionSuccess
noteDate date = 
  Lens.set Model.lastChange (Just date) >> Flow.Only


{- Commands -}

fetchDateCmd : Int -> Cmd Msg
fetchDateCmd ignored = 
  Task.perform LastChange Date.now

{- Util -}


oops : (err -> Error) -> err -> Flow.ActionResult
oops constructor err =
  constructor err |> Flow.Oops
    
success1 : Model -> Flow.ActionResult
success1 model = Flow.Success (Flow.Only model)
    
success2 : Model -> Cmd Msg -> Flow.ActionResult
success2 model cmd = Flow.Success (Flow.Both model cmd)

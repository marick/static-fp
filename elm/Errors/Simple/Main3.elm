module Errors.Simple.Main3 exposing (..)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.Exercises.FlowSolution
  exposing (always_do, whenOk_try, whenOk_do, finishWith)
import Errors.Simple.UpdateActions as Update
import Errors.Simple.View as View
import Date exposing (Date)
import Task

import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index -> 
      Ok model
        |> always_do    Update.incrementClickCount
        |> whenOk_try  (Update.incrementWordCountM person index)
        |> whenOk_do   (Update.focusOn person)
        |> finishWith   fetchDateCmd  

    ChoosePerson person ->
      Ok model
        |> whenOk_try (Update.focusOnM person)
        |> always_do   Update.incrementClickCount
        |> finishWith  fetchDateCmd

    LastChange date ->
      ( Update.noteDate date model
      , Cmd.none
      )
      
fetchDateCmd : Cmd Msg
fetchDateCmd = 
  Task.perform LastChange Date.now
        
{- Main -}    

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }


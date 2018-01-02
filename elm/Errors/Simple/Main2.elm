module Errors.Simple.Main2 exposing (..)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.View as View
import Errors.Simple.UpdateActions as Update
import Date exposing (Date)
import Task

import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index ->
      case Update.isExistingWord person index model of
        True -> 
          ( model
              |> Update.incrementClickCount
              |> Update.incrementWordCount person index
              |> Update.focusOn person
          , fetchDateCmd
          )
        False ->
          ( Update.incrementClickCount model
          , Cmd.none
          )

    ChoosePerson person ->
      case Update.isExistingPerson person model of
        True -> 
          ( model
            |> Update.focusOn person
            |> Update.incrementClickCount
          , fetchDateCmd
          )
        False ->
          ( Update.incrementClickCount model
          , Cmd.none
          )

    LastChange date ->
      ( Update.noteDate date model
      , Cmd.none
      )

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }

fetchDateCmd : Cmd Msg
fetchDateCmd = 
  Task.perform LastChange Date.now
        
    

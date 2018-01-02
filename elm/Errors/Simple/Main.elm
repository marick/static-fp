module Errors.Simple.Main exposing (..)

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
      ( model
        |> Update.incrementClickCount
        |> Update.incrementWordCount person index
        |> Update.focusOn person
      , fetchDateCmd
      )

    ChoosePerson person ->
      ( model
          |> Update.focusOn person
          |> Update.incrementClickCount
      , fetchDateCmd
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
        
    

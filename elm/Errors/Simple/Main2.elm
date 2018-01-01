module Errors.Simple.Main2 exposing (..)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.View as View
import Date exposing (Date)
import Task

import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index ->
      case Model.isExistingWord person index model of
        True -> 
          ( model
              |> Model.incrementClickCount
              |> Model.incrementWordCount person index
              |> Model.focusOn person
          , fetchDateCmd
          )
        False ->
          ( Model.incrementClickCount model
          , Cmd.none
          )

    ChoosePerson person ->
      case Model.isExistingPerson person model of
        True -> 
          ( model
            |> Model.focusOn person
            |> Model.incrementClickCount
          , fetchDateCmd
          )
        False ->
          ( Model.incrementClickCount model
          , Cmd.none
          )

    LastChange date ->
      ( Model.noteDate date model
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
        
    

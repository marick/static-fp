module Errors.Remote.Main exposing (..)

import Errors.Remote.Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model)
import Errors.Remote.Flow as Flow exposing (always_do, whenOk_do, whenOk_try, cmd)
import Errors.Remote.UpdateActions as Update 
import Errors.Remote.View as View

import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index ->
      Flow.start msg model 
        |> always_do   Update.incrementClickCount
        |> whenOk_try (Update.incrementWordCount person index)
        |> whenOk_try (Update.focusOn person)
        |> cmd         Update.fetchDateCmd
        |> Flow.finish 

    ChoosePerson person ->
      Flow.start msg model
        |> whenOk_try (Update.focusOn person)
        |> always_do   Update.incrementClickCount
        |> cmd         Update.fetchDateCmd
        |> Flow.finish

    LastChange date ->
      ( Update.noteDate date model
      , Cmd.none
      )

    LogResponse (Ok _) ->
      ( model, Cmd.none)

    LogResponse (Err err) ->
      let
        _ = Debug.log "Failed to post to remote log" err
      in
        (model, Cmd.none)
          
main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }

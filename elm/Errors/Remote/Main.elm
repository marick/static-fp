module Errors.Remote.Main exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Remote.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Remote.View as View
import Errors.Remote.RemoteLog as Log

import Lens.Try3.Lens as Lens
import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    EmphasizeWord person index ->
      model
        |> Lens.update Model.clickCount increment 
        |> Lens.updateM (Model.wordCount person index) increment
        |> Maybe.map (Lens.set Model.beloved person)
        |> finish msg model 

    LogResponse (Ok _) ->
      noCmd model

    LogResponse (Err err) ->
      let
        _ = Debug.log "Failed to post to remote log: " err
      in
        noCmd model

finish : Msg -> Model -> Maybe Model -> (Model, Cmd Msg)
finish msg originalModel maybeFinal =
  case maybeFinal of
    Just finalModel ->
      ( finalModel , Cmd.none )
    Nothing ->
      ( originalModel , Log.cmd msg )
    

          
noCmd : Model -> (Model, Cmd Msg)
noCmd model = (model, Cmd.none)

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }


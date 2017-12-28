module Errors.Alarmist.Main exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Remote.Msg exposing (Msg(..))
import Errors.Alarmist.Model as Model exposing (Model)
import Errors.Remote.View as View
import Errors.Alarmist.RemoteLog as Log
import Lens.Final.TEA.UpdateComposite as Whole exposing (Whole)

import Lens.Final.Lens as Lens
import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  Whole.pack model msg |> update_ |> Whole.unpack Log.cmd


incrementClickCount =
  Whole.map (Lens.update Model.clickCount increment)

update_ : Whole String Msg Model -> Whole String Msg Model
update_ whole =
  case whole.msg of 
    EmphasizeWord person index ->
      whole
        |> incrementClickCount
        -- |> Lens.updateM (Model.wordCount person index) increment
        -- |> Maybe.map (Lens.set Model.beloved person)
    LogResponse (Ok _) ->
      whole

    LogResponse (Err err) ->
      let
        _ = Debug.log "Failed to post to remote log: " err
      in
        whole


main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }


module Errors.Remote.Main4 exposing (..)

import Errors.Remote.Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model)
import Errors.Remote.Flow as Flow exposing (always_do, whenOk_do, whenOk_try, add)
import Errors.Remote.UpdateActions as Update 
import Errors.Remote.View as View
import Date exposing (Date)
import Task

import Html

type alias ModelState = Result Model Model

-- justModel : ModelState -> Model
-- justModel soFar =
--   case soFar of 
--     Ok model -> model
--     Err model -> model

-- ever : (Model -> a -> ModelState) -> (Model -> a) -> ModelState -> ModelState
-- ever handleResult f soFar =
--   let
--     either model =
--       model |> f |> handleResult model
--   in
--     case soFar of
--       Ok model -> either model |> justModel |> Ok 
--       Err model -> either model |> justModel |> Err

-- whenOk : (Model -> a -> ModelState) -> (Model -> a) -> ModelState -> ModelState
-- whenOk handleResult f soFar =
--   case soFar of
--     Ok model ->
--       model |> f |> handleResult model
--     Err model -> Err model

-- do : Model -> Model -> ModelState
-- do fail succeed =
--   Ok succeed

-- try : Model -> Maybe Model -> ModelState
-- try fail maybe =
--   case maybe of
--     Just succeed -> Ok succeed
--     Nothing -> Err fail

-- finishWith : Cmd Msg -> ModelState -> (Model, Cmd Msg)
-- finishWith cmd soFar = 
--   case soFar of
--     Ok model -> (model, cmd)
--     Err model -> (model, Cmd.none)
      
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index ->
      Flow.start msg model 
        |> always_do     Update.incrementClickCount
        |> whenOk_try  (Update.incrementWordCount person index)
        |> whenOk_try   (Update.focusOn person)
        |> add fetchDateCmd
        |> Flow.finish 

    ChoosePerson person ->
      Flow.start msg model
        |> whenOk_try   (Update.focusOn person)
        |> always_do       Update.incrementClickCount
        |> add fetchDateCmd
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

fetchDateCmd : Cmd Msg
fetchDateCmd = 
  Task.perform LastChange Date.now

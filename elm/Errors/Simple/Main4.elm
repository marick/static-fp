module Errors.Simple.Main4 exposing (..)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.UpdateActions as Update
import Errors.Simple.View as View
import Date exposing (Date)
import Task

import Html

type alias ModelState = Result Model Model

justModel : ModelState -> Model
justModel soFar =
  case soFar of 
    Ok model -> model
    Err model -> model

ever : (Model -> a -> ModelState) -> (Model -> a) -> ModelState -> ModelState
ever handleResult f soFar =
  let
    either model =
      model |> f |> handleResult model
  in
    case soFar of
      Ok model -> either model |> justModel |> Ok 
      Err model -> either model |> justModel |> Err

whenOk : (Model -> a -> ModelState) -> (Model -> a) -> ModelState -> ModelState
whenOk handleResult f soFar =
  case soFar of
    Ok model ->
      model |> f |> handleResult model
    Err model -> Err model

do : Model -> Model -> ModelState
do fail succeed =
  Ok succeed

try : Model -> Maybe Model -> ModelState
try fail maybe =
  case maybe of
    Just succeed -> Ok succeed
    Nothing -> Err fail

finishWith : Cmd Msg -> ModelState -> (Model, Cmd Msg)
finishWith cmd soFar = 
  case soFar of
    Ok model -> (model, cmd)
    Err model -> (model, Cmd.none)
      
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index -> 
      Ok model
        |> ever do      Update.incrementClickCount
        |> whenOk try  (Update.incrementWordCountM person index)
        |> whenOk do   (Update.focusOn person)
        |> finishWith   fetchDateCmd  

    ChoosePerson person ->
      Ok model
        |> whenOk try   (Update.focusOnM person)
        |> ever do       Update.incrementClickCount
        |> finishWith    fetchDateCmd

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

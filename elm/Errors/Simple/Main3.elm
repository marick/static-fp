module Errors.Simple.Main3 exposing (..)

import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
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
        |> finish       fetchDateCmd  

    ChoosePerson person ->
      Ok model
        |> whenOk_try (Update.focusOnM person)
        |> always_do   Update.incrementClickCount
        |> finish      fetchDateCmd

    LastChange date ->
      ( Update.noteDate date model
      , Cmd.none
      )
      
{- Util -}

type alias ModelState = Result Model Model

always_do : (Model -> Model) -> ModelState -> ModelState
always_do f soFar =
  case soFar of
    Ok model -> Ok <| f model
    Err model -> Err <| f model

whenOk_do : (Model -> Model) -> ModelState -> ModelState
whenOk_do = Result.map

whenOk_try : (Model -> Maybe Model) -> ModelState -> ModelState
whenOk_try f soFar = 
  let
    process model =
      case f model of
        Just newModel -> Ok newModel
        Nothing -> Err model
  in
    case soFar of
      Ok model -> process model
      e -> e

finish : Cmd Msg -> ModelState -> (Model, Cmd Msg)
finish cmd soFar = 
  case soFar of
    Ok model -> (model, cmd)
    Err model -> (model, Cmd.none)
      
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


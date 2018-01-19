module Errors.Exercises.Duplication.Flow exposing (..)
import Lens.Final.Lens as Lens
import Array exposing (Array)
import Errors.Remote.Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model)
import Errors.Remote.Errors exposing (Error)
import Errors.Remote.State as State exposing (State)
import Errors.Remote.RemoteLog as Log
import Errors.Remote.Errors as Error


start : Msg -> Model -> State Error
start msg model =
  { model = model
  , originalForReference = model
  , msg = msg
  , cmds = Array.empty

  , err = Nothing
  }

always_do : (Model -> Model) -> State Error -> State Error
always_do modelAction state =
  Lens.update State.model modelAction state

whenOk_do : (Model -> Model) -> State Error -> State Error
whenOk_do modelAction state =
  case state.err of
    Nothing -> always_do modelAction state
    _ -> state
    
whenOk_try : (Model -> Result Error Model) -> State Error -> State Error
whenOk_try modelAction state =
  case state.err of
    Nothing ->
      case modelAction state.model of
        Ok newModel ->
          Lens.set State.model newModel state
        Err err ->
          Lens.set State.err (Just err) state
    _ ->
      state

cmd : Cmd Msg -> State Error -> State Error
cmd msg state = 
  Lens.update State.cmds (Array.push msg) state

        
finish : State Error -> (Model, Cmd Msg)
finish state =
  case state.err of
    Nothing ->
      ( state.model
      , state.cmds |> Array.toList |> Cmd.batch
      )
    Just err ->
      ( state.model
      , Log.cmd <| Error.jsonify state err
      )


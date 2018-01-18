module Errors.Exercises.AllBoth.Flow exposing (..)
import Lens.Final.Lens as Lens
import Array exposing (Array)
import Errors.Remote.Msg exposing (Msg(..))
import Errors.Remote.Model as Model exposing (Model)
import Errors.Remote.Errors exposing (Error)
import Errors.Remote.State as State exposing (State)
import Errors.Remote.RemoteLog as Log
import Errors.Remote.Errors as Error

type ActionSuccess
  = Only Model
  | Both Model (Cmd Msg)

type ActionResult 
  = Success ActionSuccess
  | Oops Error

handleSuccess : State Error -> ActionSuccess -> State Error
handleSuccess state success =
  let
    setModel = Lens.set State.model
  in
    case success of
      Only newModel ->
        state |> setModel newModel
      Both newModel newCmd ->
        state |> setModel newModel |> cmd newCmd

start : Msg -> Model -> State Error
start msg model =
  { model = model
  , originalForReference = model
  , msg = msg
  , cmds = Array.empty

  , err = Nothing
  }

always_do : (Model -> ActionSuccess) -> State Error -> State Error
always_do modelAction state =
  modelAction state.model |> handleSuccess state

whenOk_do : (Model -> ActionSuccess) -> State Error -> State Error
whenOk_do modelAction state =
  case state.err of
    Nothing -> always_do modelAction state
    _ -> state
    
whenOk_try : (Model -> ActionResult) -> State Error -> State Error
whenOk_try modelAction state =
  case modelAction state.model of
    Success success ->
      handleSuccess state success
    Oops err ->
      Lens.set State.err (Just err) state

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


module Errors.Remote.Errors exposing (..)

import Json.Encode as Json
import Lens.Final.Lens as Lens exposing (BadPath)
import Errors.Remote.State as State exposing (State)

type Error
  = MissingWord BadPath
  | MissingPerson BadPath

jsonify : State Error -> Error -> Json.Value
jsonify state error =
  case error of
    MissingWord path ->
      pathErr "MissingWord" state path
    MissingPerson path -> 
      pathErr "MissingPerson" state path

pathErr : String -> State Error -> BadPath -> Json.Value        
pathErr errorId state path =
  Json.object
    [ ("app", Json.string "Errors.Remote.Errors")
    , ("id", Json.string errorId)
    , ("msg", Json.string <| toString state.msg)
    , ("path", Json.list <| List.map Json.string path)
    ]
    

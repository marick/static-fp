module Errors.Remote.Errors exposing (..)

import Json.Encode as Encode
import Lens.Final.Lens as Lens exposing (BadPath)
import Errors.Remote.State as State exposing (State)

type Error
  = MissingWord BadPath
  | MissingPerson BadPath

jsonify : State Error -> Error -> Encode.Value
jsonify state error =
  case error of
    MissingWord path ->
      pathErr "MissingWord" state path
    MissingPerson path -> 
      pathErr "MissingPerson" state path

pathErr : String -> State Error -> BadPath -> Encode.Value        
pathErr tag state path =
  Encode.object
    [ ("app", Encode.string "Errors.Remote.Errors")
    , ("tag", Encode.string tag)
    , ("msg", Encode.string <| toString state.msg)
    , ("path", Encode.list <| List.map Encode.string path)
    ]
    

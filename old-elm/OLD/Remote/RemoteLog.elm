module Errors.Remote.RemoteLog exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Errors.Remote.Msg exposing (Msg(..))

destination : String
destination = "http://logger.outsidefp.com"


jsonify : Msg -> Encode.Value
jsonify msg =
  case msg of
    EmphasizeWord person index ->
      Encode.object
        [ ("type", Encode.string "EmphasizeWord")
        , ("person", Encode.string person)
        , ("index", Encode.int index)
        ]
    _ ->
      Encode.object
        [ ("type", Encode.string "impossible")
        , ("msg", Encode.string (toString msg) )
        , ( "note"
          , Encode.string
              "`payload` called for `Msg` that should not be logged."
          )
        ]
      


cmd : Msg -> Cmd Msg
cmd msg =
  let
    payload = jsonify msg |> Http.jsonBody
  in
    Decode.succeed "ok" -- Logging is "fire and forget"
      |> Http.post destination payload
      |> Http.send LogResponse
           

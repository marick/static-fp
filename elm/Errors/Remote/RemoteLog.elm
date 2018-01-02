module Errors.Remote.RemoteLog exposing (..)

import Http
import Errors.Remote.Msg exposing (Msg(LogResponse))
import Json.Encode
import Json.Decode


destination : String
destination = "http://logger.outsidefp.com"

cmd : Json.Encode.Value -> Cmd Msg
cmd payload =
  Json.Decode.succeed "ok" -- Logging is "fire and forget"
    |> Http.post destination (Http.jsonBody payload)
    |> Http.send LogResponse
           

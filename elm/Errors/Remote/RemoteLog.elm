module Errors.Remote.RemoteLog exposing (..)

import Http
import Errors.Remote.Msg exposing (Msg(LogResponse))
import Json.Encode as Encode
import Json.Decode as Decode


destination : String
destination = "http://logger.outsidefp.com"

cmd : Encode.Value -> Cmd Msg
cmd payload =
  let
    _ = Debug.log "Will log this" (Encode.encode 4 payload)
  in
    Decode.succeed "ok" -- Logging is "fire and forget"
      |> Http.post destination (Http.jsonBody payload)
      |> Http.send LogResponse
           


         

module Errors.Alarmist.RemoteLog exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Errors.Remote.Msg exposing (Msg(..))
import Lens.Final.TEA.UpdateComposite as Whole exposing (Whole)

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


cmd : Whole String Msg model -> String -> Cmd Msg
cmd whole msg =
  let
    payload = jsonify whole.msg |> Http.jsonBody
  in
    Decode.succeed "ok" -- Logging is "fire and forget"
      |> Http.post destination payload
      |> Http.send LogResponse
           

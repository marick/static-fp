module Errors.Remote.Errors exposing (..)

import Json.Encode as Encode
import Lens.Final.Lens as Lens exposing (BadPath)
import Errors.Remote.State as State exposing (State)

type Error
  = MissingWord BadPath
  | MissingPerson BadPath

jsonify : State Error -> Error -> Encode.Value
jsonify state error =
  Encode.object
    [("msg", Encode.string "foo")]
--   case msg of
--     EmphasizeWord person index ->
--       Encode.object
--         [ ("type", Encode.string "EmphasizeWord")
--         , ("person", Encode.string person)
--         , ("index", Encode.int index)
--         ]
--     _ ->
--       Encode.object
--         [ ("type", Encode.string "impossible")
--         , ("msg", Encode.string (toString msg) )
--         , ( "note"
--           , Encode.string
--               "`payload` called for `Msg` that should not be logged."
--           )
--         ]
      

    

--     payload = Error.jsonify msg |> Http.jsonBody

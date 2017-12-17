module Errors.V1.Main3 exposing (..)

import Errors.V1.Basics exposing (..)
import Errors.V1.Msg exposing (Msg(..))
import Errors.V1.Model as Model exposing (Model)
import Errors.V1.View as View 

import Lens.Try3.Lens as Lens
import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    EmphasizeWord person index ->
      model
        |> Lens.update Model.clickCount increment 
        |> Lens.updateM (Model.wordCount person index) increment
        |> Maybe.map (Lens.set Model.beloved person)
        |> Maybe.withDefault model
        |> noCmd

noCmd : Model -> (Model, Cmd Msg)
noCmd model = (model, Cmd.none)

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }


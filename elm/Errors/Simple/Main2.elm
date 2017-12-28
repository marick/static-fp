module Errors.Simple.Main2 exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.View as View 

import Lens.Try4.Lens as Lens
import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    EmphasizeWord person index ->
      model
        |> Lens.update Model.clickCount increment 
        |> maybeEmphasizeWord person index
        |> noCmd

maybeEmphasizeWord : String -> Int -> Model -> Model
maybeEmphasizeWord person index model =
  case Lens.exists (Model.word person index) model of
    False ->
      model
    True ->
      model
        |> Lens.set Model.beloved person
        |> Lens.update (Model.wordCount person index) increment

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

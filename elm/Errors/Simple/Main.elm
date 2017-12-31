module Errors.Simple.Main exposing (..)

import Errors.Simple.Basics exposing (..)
import Errors.Simple.Msg exposing (Msg(..))
import Errors.Simple.Model as Model exposing (Model)
import Errors.Simple.View as View
import Date exposing (Date)
import Task

import Lens.Final.Lens as Lens
import Html

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    Like person index -> 
      ( model
        |> Lens.update Model.clickCount increment
        |> Lens.set Model.focusPerson person
        |> Lens.update (Model.wordCount person index) increment
      , Task.perform LastChange Date.now
      )

    LastChange date ->
      ( Lens.set Model.lastChange (Just date) model
      , Cmd.none
      )

    ChoosePerson who ->
      ( Lens.set Model.focusPerson who model
      , Task.perform LastChange Date.now
      )
        
  

main : Program Never Model Msg
main =
  Html.program
    { init = Model.init
    , view = View.view
    , update = update
    , subscriptions = always Sub.none
    }

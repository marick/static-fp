module IVFinal.IV exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Tagged exposing (Tagged(..))

import IVFinal.Measures as Measure
import IVFinal.Apparatus as Apparatus
import IVFinal.FloatString as FloatString exposing (FloatString)
import IVFinal.Util.EuclideanTypes exposing (Rectangle)
import IVFinal.Util.EuclideanRectangle as Rectangle

import IVFinal.View.Layout as Layout
import IVFinal.Form as Form

import IVFinal.Types exposing (..)

-- Model

updateDesiredDripRate candidate model =
  { model |
      desiredDripRate =
        FloatString.fromString model.desiredDripRate candidate }

-- Update

startingModel : Model
startingModel =
  { desiredDripRate = FloatString.fromFloat 0.0
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeDripRate candidate ->
      ( model |> updateDesiredDripRate candidate
      , Cmd.none
      )
    _ -> (model , Cmd.none)

-- View

view : Model -> Html Msg
view model =
  Layout.wrapper 
    [ Layout.canvas Apparatus.view
    , Layout.form (Form.view model)
    ]


-- Main
      
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
    

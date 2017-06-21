module IVFinal.IV exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Tagged exposing (Tagged(..))

import IVFinal.Measures as Measure
import IVFinal.Apparatus as Apparatus
import IVFinal.FloatString as FloatString exposing (FloatString)
import IVFinal.Util.EuclideanTypes exposing (Rectangle)
import IVFinal.Util.EuclideanRectangle as Rectangle

import IVFinal.View.Layout as Layout

-- Model

type alias Model =
  { desiredDripRate : FloatString
  }

updateDesiredDripRate candidate model =
  { model |
      desiredDripRate =
        FloatString.fromString model.desiredDripRate candidate }

-- Msg  


type Msg
  = ChangeDripRate String

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

-- View

canvas : Rectangle
canvas = Rectangle.fromOrigin 400 400 

view : Model -> Html Msg
view model =
  Layout.wrapper 
    [ Layout.canvas Apparatus.view
    , p []
        [ text "Drops per second: "
        , input [ type_ "text"
                , value <| Tagged.untag model.desiredDripRate
                , Event.onInput ChangeDripRate
                ]
            []
        ]
    ]


-- Main
      
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
    

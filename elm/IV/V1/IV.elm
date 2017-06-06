module IV.V1.IV exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Tagged exposing (Tagged(..))

import IV.Common.Measures as Measure
import IV.Common.Svg as Svg
import IV.Common.Html as H
import IV.V1.Apparatus as Apparatus
import IV.V1.FloatString as FloatString exposing (FloatString)

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

view : Model -> Html Msg
view model =
  H.wrapper 
    [ Svg.wrapper Apparatus.view
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
    

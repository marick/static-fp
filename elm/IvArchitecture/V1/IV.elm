module IvArchitecture.V1.IV exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IvArchitecture.Common.Measures as Measure
import IvArchitecture.Common.Svg as Svg
import IvArchitecture.Common.Html as Html
import Tagged exposing (Tagged(..))

-- Model

type alias Model =
  { dripRate : Measure.FloatString
  } 

-- Msg  

type Msg
  = ChangeDripRate String

-- Update

startingModel : Model
startingModel =
  { dripRate = Measure.toFloatString 0
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeDripRate desired ->
      ( model, Cmd.none )

-- View

view : Model -> Html Msg
view model =
  Html.wrapper 
    [ Svg.wrapper []
    , p []
        [ text "Drops per second: "
        , input [ type_ "text"
                , value <| Tagged.untag model.dripRate
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

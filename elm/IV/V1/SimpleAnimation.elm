module IV.V1.IV exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Tagged exposing (Tagged(..))

import Animation

import IV.Common.AppSvg as AppSvg
import IV.Common.AppAnimation as AppAnimation
import IV.Common.AppHtml as H
import IV.V1.Apparatus as Apparatus
import IV.V1.FloatString as FloatString exposing (FloatString)
import IV.Common.EuclideanTypes exposing (Rectangle)
import IV.Common.EuclideanRectangle as Rectangle

-- Model

type alias Model =
  { desiredDripRate : FloatString
  , dropletStyle : Animation.State
  }

updateDesiredDripRate : String -> Model -> Model  
updateDesiredDripRate candidate model =
  { model |
      desiredDripRate =
        FloatString.fromString model.desiredDripRate candidate }

-- Msg  

type Msg
  = UserEditsDripRate String
  | UserCommitsToDripRate
  | AnimationTick Animation.Msg

-- Update

startingModel : Model
startingModel =
  { desiredDripRate = FloatString.fromFloat 0.0
  , dropletStyle = Animation.style AppAnimation.invisibleDrop
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UserEditsDripRate candidate ->
      ( model |> updateDesiredDripRate candidate
      , Cmd.none
      )

    UserCommitsToDripRate ->
      let
        newStyle = Animation.interrupt [Animation.set AppAnimation.hangingDrop]  model.dropletStyle
      in
        ( { model | dropletStyle = newStyle }
        , Cmd.none
        )

    AnimationTick state ->
      ( { model | dropletStyle = Animation.update state model.dropletStyle }
      , Cmd.none
      )

-- View

canvas : Rectangle
canvas = Rectangle.fromOrigin 400 400 

view : Model -> Html Msg
view model =
  H.wrapper 
    [ AppSvg.canvas canvas Apparatus.view
    , p []
        [ text "Drops per second: "
        , input [ type_ "text"
                , size 6
                , value <| Tagged.untag model.desiredDripRate
                , Event.onInput UserEditsDripRate
                , Event.onBlur UserCommitsToDripRate
                ]
            []
        ]
    ]

-- Main

subscriptions model =
  Animation.subscription AnimationTick [ model.dropletStyle ]
      
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

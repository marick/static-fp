module Animation.A1 exposing (..)

import Animation.Layout as Layout

import Animation
import Html exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA

type Msg
  = Start
  | Tick Animation.Msg

type alias AnimationModel = Animation.State

type alias Model =
  { droplet : AnimationModel
  }

init : (Model, Cmd Msg)
init = ({ droplet = Animation.style [ Animation.y 10 ] }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model |
            droplet = 
              Animation.interrupt
                [ Animation.to [ Animation.y 200 ] ]
                model.droplet
        }
      , Cmd.none
      )

    Tick subMsg ->
      ( { model |
            droplet =
            Animation.update subMsg model.droplet
        }
      , Cmd.none
      )


view : Model -> Html Msg
view model =
  let
    fixedPart =
      [ SA.height "20"
      , SA.width "20"
      , SA.fill "grey"
      , SA.x "300"
      ]
    animatedPart =
      Animation.render model.droplet
  in
    Layout.wrapper
      [ Layout.canvas
          [ S.rect
            (fixedPart ++ animatedPart)
            []
          ]
      , Layout.button Start "Click Me"
      ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.droplet ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

module Animation.Droplet exposing (..)

import Html as H exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation.Common as C exposing (Msg(..))
import Animation

type Msg
  = Start
  | Tick Animation.Msg

type alias AnimationModel = Animation.State

type alias Model =
  { droplet : C.AnimationModel
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
  C.wrapper
    [ C.canvas
        [ S.rect
            ([ SA.height "20"
             , SA.width "20"
             , SA.fill "grey"
             , SA.x "300"
             ] ++ Animation.render model.droplet)
            []
        ]
    , C.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.droplet ]

    
main : Program Never Model Msg
main =
  H.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

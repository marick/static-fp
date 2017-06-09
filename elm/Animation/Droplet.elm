module Animation.Droplet exposing (..)

import Html as H exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation.Common as C

type alias Model =
  { dropletAnimatables : Animation.State
  }

type Msg
  = Start
  | Tick Animation.Msg

init : (Model, Cmd Msg)
init = ({ dropletAnimatables =
            Animation.style
              [ Animation.x 200
              , Animation.y 10
              ]
        }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model |
            dropletAnimatables = 
              Animation.interrupt
                [ Animation.to
                    [ Animation.x 200
                    , Animation.y 300
                    ]
                ]
                model.dropletAnimatables
        }
      , Cmd.none
      )
    Tick animationMsg ->
      let
        newStyle = Animation.update animationMsg model.dropletAnimatables
      in
        ( { model | dropletAnimatables = newStyle }
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
             ] ++ Animation.render model.dropletAnimatables)
            []
        ]
    , C.button Start "Press Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.dropletAnimatables ]

    
main : Program Never Model Msg
main =
  H.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

module Animation.Stopping exposing (..)

import Html exposing (Html)
import Animation.MessengerCommon as C
import Animation
import Animation.Messenger

type alias AnimationState = Animation.Messenger.State Msg

type alias Model =
  { dropletAnimatables : AnimationState
  , fluidAnimatables : AnimationState
  }

startDroplet : AnimationState -> AnimationState
startDroplet previousAnimation  =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStart 
        , Animation.toWith C.dropletControl C.dropletEnd
        ]
    ]
    previousAnimation
  
stopDroplet : AnimationState -> AnimationState
stopDroplet previousAnimation =
  Animation.interrupt
    [ Animation.set C.dropletStart ]
    previousAnimation
  
startFluid : AnimationState -> AnimationState
startFluid previousAnimation  =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEnd
    , Animation.Messenger.send Stop
    ]
    previousAnimation



-- The usual functions
  
type Msg
  = Start
  | Tick Animation.Msg
  | Stop

init : (Model, Cmd Msg)
init = ( { dropletAnimatables = Animation.style C.dropletStart
         , fluidAnimatables = Animation.style C.fluidStart
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
            | dropletAnimatables = startDroplet model.dropletAnimatables
            , fluidAnimatables = startFluid model.fluidAnimatables
        }
      , Cmd.none
      )
           
    Tick animationMsg ->
      let
        (newDroplet, dropletCmd) =
          Animation.Messenger.update animationMsg model.dropletAnimatables
        (newFluid, fluidCmd) = 
          Animation.Messenger.update animationMsg model.fluidAnimatables
      in
        ( { model 
              | dropletAnimatables = newDroplet
              , fluidAnimatables = newFluid
          }
        , Cmd.batch [dropletCmd, fluidCmd]
        )

    Stop ->
      ( { model
            | dropletAnimatables = stopDroplet model.dropletAnimatables
        }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas [ C.droplet model.dropletAnimatables
               , C.fluid model.fluidAnimatables
               ]
    , C.button Start "Start"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.dropletAnimatables
                              , model.fluidAnimatables
                              ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

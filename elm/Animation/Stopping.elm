module Animation.Stopping exposing (..)

import Html as H exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation.MessengerCommon as C
import Animation
import Animation.Messenger

type alias Model =
  { dropletAnimatables : Animation.Messenger.State Msg
  , fluidAnimatables : Animation.Messenger.State Msg
  }

startDroplet : Animation.Messenger.State Msg -> Animation.Messenger.State Msg
startDroplet previousAnimation  =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStart 
        , Animation.toWith C.dropletControl C.dropletEnd
        ]
    ]
    previousAnimation
  
stopDroplet : Animation.Messenger.State Msg -> Animation.Messenger.State Msg
stopDroplet previousAnimation =
  Animation.interrupt
    [ Animation.set C.dropletStart ]
    previousAnimation
  
startFluid : Animation.Messenger.State Msg -> Animation.Messenger.State Msg
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

updateDroplet : (Animation.Messenger.State Msg -> Animation.Messenger.State Msg) -> Model -> Model
updateDroplet f model =
  { model |
      dropletAnimatables = f model.dropletAnimatables
  }

  
updateFluid : (Animation.Messenger.State Msg -> Animation.Messenger.State Msg) -> Model -> Model
updateFluid f model =
  { model |
      fluidAnimatables = f model.fluidAnimatables
  }

  
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      model
        |> updateDroplet startDroplet
        |> updateFluid startFluid
        |> C.noCmd
           
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
      model
        |> updateDroplet stopDroplet
        |> C.noCmd

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
  H.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

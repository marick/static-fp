module Animation.FluidSolution exposing (..)

import Html exposing (Html)
import Animation.Common as C
import Animation

type alias Model =
  { dropletAnimatables : Animation.State
  , fluidAnimatables : Animation.State
  }

startDroplet : Animation.State -> Animation.State
startDroplet previousAnimation  =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStart 
        , Animation.toWith C.dropletControl C.dropletEnd
        ]
    ]
    previousAnimation
  
startFluid : Animation.State -> Animation.State
startFluid previousAnimation  =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEnd
    ]
    previousAnimation
  
-- The usual functions
  
type Msg
  = Start
  | Tick Animation.Msg

init : (Model, Cmd Msg)
init = ( { dropletAnimatables = Animation.style C.dropletStart
         , fluidAnimatables = Animation.style C.fluidStart
         }
       , Cmd.none
       )

updateDroplet : (Animation.State -> Animation.State) -> Model -> Model
updateDroplet f model =
  { model |
      dropletAnimatables = f model.dropletAnimatables
  }

  
updateFluid : (Animation.State -> Animation.State) -> Model -> Model
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
      model
        |> updateDroplet (Animation.update animationMsg)
        |> updateFluid (Animation.update animationMsg)
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
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

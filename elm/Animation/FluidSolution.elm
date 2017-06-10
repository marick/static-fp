module Animation.FluidSolution exposing (..)

import Html exposing (Html)
import Animation.Common as C exposing (Msg(..))
import Animation

type alias Model =
  { droplet : C.AnimationModel
  , fluid : C.AnimationModel
  }

startDroplet : C.AnimationModel -> C.AnimationModel
startDroplet =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStartStyles
        , Animation.toWith C.dropletControl C.dropletEndStyles
        ]
    ]
  
startFluid : C.AnimationModel -> C.AnimationModel
startFluid =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEndStyles
    ]
  
-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { droplet = Animation.style C.dropletStartStyles
         , fluid = Animation.style C.fluidStartStyles
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
          | droplet = startDroplet model.droplet
          , fluid = startFluid model.fluid
        }
      , Cmd.none
      )
           
    Tick subMsg ->
      ( { model
          | droplet = Animation.update subMsg model.droplet
          , fluid = Animation.update subMsg model.fluid
        }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas [ C.dropletView model.droplet
               , C.fluidView model.fluid
               ]
    , C.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick
    [ model.droplet
    , model.fluid
    ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

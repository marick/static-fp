module Animation.Stopping exposing (..)

import Html exposing (Html)
import Animation.MessengerCommon as C exposing (Msg(..))
import Animation
import Animation.Messenger

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
  
stopDroplet : C.AnimationModel -> C.AnimationModel
stopDroplet =
  Animation.interrupt
    [ Animation.set C.dropletStartStyles ]
  
startFluid : C.AnimationModel -> C.AnimationModel
startFluid =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEndStyles
    , Animation.Messenger.send Stop
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
      let
        (newDroplet, dropletCmd) =
          Animation.Messenger.update subMsg model.droplet
        (newFluid, fluidCmd) = 
          Animation.Messenger.update subMsg model.fluid
      in
        ( { model 
              | droplet = newDroplet
              , fluid = newFluid
          }
        , Cmd.batch [dropletCmd, fluidCmd]
        )

    Stop ->
      ( { model
            | droplet = stopDroplet model.droplet
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
    

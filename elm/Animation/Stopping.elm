module Animation.Stopping exposing (..)

import Html exposing (Html)
import Animation.MessengerCommon as C exposing (Msg(..))
import Animation
import Animation.Messenger

type alias Model =
  { droplet : C.AnimationModel
  , fluid : C.AnimationModel
  }

dropletFalls : C.AnimationModel -> C.AnimationModel
dropletFalls =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletInitStyles 
        , Animation.toWith C.dropletControl C.dropletFallenStyles
        ]
    ]
  
dropletStops : C.AnimationModel -> C.AnimationModel
dropletStops =
  Animation.interrupt
    [ Animation.set C.dropletInitStyles ]
  
fluidDrains : C.AnimationModel -> C.AnimationModel
fluidDrains =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidLastStyles
    , Animation.Messenger.send Stop
    ]

-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { droplet = Animation.style C.dropletInitStyles
         , fluid = Animation.style C.fluidInitStyles
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
            | droplet = dropletFalls model.droplet
            , fluid = fluidDrains model.fluid
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
            | droplet = dropletStops model.droplet
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
    

module Animation.Stopping exposing (..)

import Html exposing (Html)
import Animation.MessengerCommon as C exposing (Msg(..))
import Animation
import Animation.Messenger

type alias Model =
  { dropletStyle : C.AnimationModel
  , fluidStyle : C.AnimationModel
  }

startDroplet : C.AnimationModel -> C.AnimationModel
startDroplet =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStartStyle 
        , Animation.toWith C.dropletControl C.dropletEndStyle
        ]
    ]
  
stopDroplet : C.AnimationModel -> C.AnimationModel
stopDroplet =
  Animation.interrupt
    [ Animation.set C.dropletStartStyle ]
  
startFluid : C.AnimationModel -> C.AnimationModel
startFluid =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEndStyle
    , Animation.Messenger.send Stop
    ]

-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { dropletStyle = Animation.style C.dropletStartStyle
         , fluidStyle = Animation.style C.fluidStartStyle
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
            | dropletStyle = startDroplet model.dropletStyle
            , fluidStyle = startFluid model.fluidStyle
        }
      , Cmd.none
      )
           
    Tick subMsg ->
      let
        (newDroplet, dropletCmd) =
          Animation.Messenger.update subMsg model.dropletStyle
        (newFluid, fluidCmd) = 
          Animation.Messenger.update subMsg model.fluidStyle
      in
        ( { model 
              | dropletStyle = newDroplet
              , fluidStyle = newFluid
          }
        , Cmd.batch [dropletCmd, fluidCmd]
        )

    Stop ->
      ( { model
            | dropletStyle = stopDroplet model.dropletStyle
        }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas [ C.dropletView model.dropletStyle
               , C.fluidView model.fluidStyle
               ]
    , C.button Start "Start"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick
    [ model.dropletStyle
    , model.fluidStyle
    ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

module Animation.FluidSolution exposing (..)

import Html exposing (Html)
import Animation.Common as C exposing (Msg(..))
import Animation

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
  
startFluid : C.AnimationModel -> C.AnimationModel
startFluid =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidEndStyle
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
      ( { model
          | dropletStyle = Animation.update subMsg model.dropletStyle
          , fluidStyle = Animation.update subMsg model.fluidStyle
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
    

module Animation.DropletControl exposing (..)

import Html exposing (Html)
import Animation.Common as C exposing (Msg(..))
import Animation

type alias Model =
  { droplet : C.AnimationModel
  }

startDroplet : C.AnimationModel -> C.AnimationModel
startDroplet =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set C.dropletStartStyles
        , Animation.toWith C.dropletControl C.dropletEndStyles
        ]
    ]
  
-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { droplet = Animation.style C.dropletStartStyles }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model | droplet = startDroplet model.droplet }
      , Cmd.none
      )
           
    Tick subMsg ->
      ( { model | droplet = Animation.update subMsg model.droplet }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas [ C.dropletView model.droplet ]
    , C.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.droplet ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

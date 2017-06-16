module Animation.DropletTidy exposing (..)

import Html exposing (Html)
import Animation.Common as C exposing (Msg(..))
import Animation

type alias Model =
  { droplet : C.AnimationModel
  }

dropletFalls : C.AnimationModel -> C.AnimationModel
dropletFalls =
  Animation.interrupt
    [ Animation.to C.dropletFallenStyles ]

-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { droplet = Animation.style C.dropletInitStyles }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model | droplet = dropletFalls model.droplet }
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
    

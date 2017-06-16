module Animation.X exposing (..)

import Html exposing (Html)
import Animation.Common as C exposing (Msg(..))
import Animation
import Time
import Ease

type alias Model =
  { droplet : C.AnimationModel
  , fluid : C.AnimationModel
  }


dropletInitStyles : List Animation.Property
dropletInitStyles =
  [ Animation.y 10
  , Animation.opacity 0
  ]

dropletFormedStyles : List Animation.Property
dropletFormedStyles =
  [ Animation.y 10
  , Animation.opacity 1.0
  ]

dropletFallenStyles : List Animation.Property
dropletFallenStyles =
  [ Animation.y 200
  , Animation.opacity 1.0
  ]


-- Added for DropletEasing.elm




dropletForming : Animation.Interpolation  
dropletForming =
  Animation.easing
    { duration = Time.second * 0.5
    , ease = Ease.linear
    }

dropletFalling : Animation.Interpolation  
dropletFalling =
  Animation.easing
    { duration = Time.second * 0.3
    , ease = Ease.inQuad
    }


  
dropletFalls : C.AnimationModel -> C.AnimationModel
dropletFalls =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set dropletInitStyles
        , Animation.toWith dropletForming dropletFormedStyles
        , Animation.toWith dropletFalling dropletFallenStyles
        ]
    ]
  
fluidDrains : C.AnimationModel -> C.AnimationModel
fluidDrains =
  Animation.interrupt
    [ Animation.toWith C.fluidControl C.fluidDrainedStyles
    ]
  
-- The usual functions
  
init : (Model, Cmd Msg)
init = ( { droplet = Animation.style dropletInitStyles
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
    

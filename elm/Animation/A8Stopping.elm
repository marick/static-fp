module Animation.A8Stopping exposing (main)

import Animation.A8Stopping.Droplet as Droplet
import Animation.A8Stopping.Types exposing (..)
import Animation.A8Stopping.Fluid as Fluid

import Animation.Layout as Layout
import Html exposing (Html)
import Animation
import Animation.Messenger

-- Two changes to `update`:
-- 1. A new `StopDripping` case has been added.
-- 2. `Tick` needs to forward on `Msg`s from Animate.Messenger.update


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
          | droplet = Droplet.falls model.droplet
          , fluid = Fluid.drains model.fluid
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

    StopDripping ->
      ( { model
            | droplet = Droplet.stops model.droplet
        }
      , Cmd.none
      )



--- The rest is unchanged

init : (Model, Cmd Msg)
init = ( { droplet = Animation.style Droplet.initStyles
         , fluid = Animation.style Fluid.initStyles
         }
       , Cmd.none
       )

view : Model -> Html Msg
view model =
  Layout.wrapper
    [ Layout.canvas [ Droplet.view model.droplet
                    , Fluid.view model.fluid
                    ]
    , Layout.button Start "Click Me"
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
    

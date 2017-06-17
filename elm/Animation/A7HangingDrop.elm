module Animation.A7HangingDrop exposing (main)

import Animation.A7HangingDrop.Droplet as Droplet
import Animation.A6FluidSolution.Types exposing (..)  -- No changes, so use old file
import Animation.A6FluidSolution.Fluid as Fluid    -- No changes, so use old file

import Animation.Layout as Layout
import Html exposing (Html)
import Animation

init : (Model, Cmd Msg)
init = ( { droplet = Animation.style Droplet.initStyles
         , fluid = Animation.style Fluid.initStyles
         }
       , Cmd.none
       )

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
      ( { model
          | droplet = Animation.update subMsg model.droplet
          , fluid = Animation.update subMsg model.fluid
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
    

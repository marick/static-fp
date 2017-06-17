module Animation.A6FluidSolution exposing (main)

import Animation.A6FluidSolution.Types exposing (..)
import Animation.A6FluidSolution.Droplet as Droplet -- Nothing to change for A6 version
import Animation.A6FluidSolution.Fluid as Fluid

import Animation.Layout as Layout
import Html exposing (Html)
import Animation

init : (Model, Cmd Msg)
init = ( { droplet = Animation.style Droplet.initStyles
         , fluid = Animation.style Fluid.initStyles     -- Added
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model
          | droplet = Droplet.falls model.droplet
          , fluid = Fluid.drains model.fluid          -- Added
        }
      , Cmd.none
      )
           
    Tick subMsg ->
      ( { model
          | droplet = Animation.update subMsg model.droplet
          , fluid = Animation.update subMsg model.fluid       -- Added
        }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  Layout.wrapper
    [ Layout.canvas [ Droplet.view model.droplet
                    , Fluid.view model.fluid        -- Added
                    ]
    , Layout.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick
    [ model.droplet
    , model.fluid                    -- Added
    ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

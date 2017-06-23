module IVFinal.IV exposing (..)

import Html exposing (..)
import Animation
import Animation.Messenger

import IVFinal.Apparatus as Apparatus
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.View.InputFields as Field

import IVFinal.View.Layout as Layout
import IVFinal.Form as Form

import IVFinal.Types exposing (..)

  

startingModel : Model
startingModel =
  { desiredDripRate = Field.dripRate ""
  , droplet = Animation.style Droplet.initStyles
  }

init : (Model, Cmd Msg)
init = ( startingModel, Cmd.none )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeDripRate candidate ->
      ( { model |
            desiredDripRate = Field.dripRate candidate
        }
      , Cmd.none
      )

    StartDripping ->
      ( { model
            | droplet = Droplet.falls model
        }
      , Cmd.none
      )
      
    Tick subMsg ->
      let
        (newDroplet, dropletCmd) =
          Animation.Messenger.update subMsg model.droplet
      in
        ( { model | droplet = newDroplet }
        , Cmd.batch [dropletCmd]
        )

    _ -> (model , Cmd.none)



view : Model -> Html Msg
view model =
  Layout.wrapper 
    [ Layout.canvas <| Apparatus.view model
    , Layout.form <| Form.view model
    ]




subscriptions : Model -> Sub Msg
subscriptions model =
  Animation.subscription Tick
    [ model.droplet
    ]

      
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

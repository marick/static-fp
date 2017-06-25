module IVFinal.IV exposing (..)

import Html exposing (..)
import Animation
import Animation.Messenger

import IVFinal.Apparatus as Apparatus
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.View.InputFields as Field
import IVFinal.Measures as Measure

import IVFinal.View.Layout as Layout
import IVFinal.Form as Form

import IVFinal.Types exposing (..)


makeFieldsEmpty : Model -> Model
makeFieldsEmpty model = 
  { model
      | desiredDripRate = Field.dripRate ""
      , desiredMinutes = Field.minutes "0"
      , desiredHours = Field.hours "0"
  }

startingModel : Model
startingModel =
  { desiredDripRate = Field.dripRate ""
  , desiredMinutes = Field.minutes "0"
  , desiredHours = Field.hours "0"

  , droplet = Animation.style Droplet.initStyles
  , bagFluid = Animation.style BagFluid.initStyles
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

    ChangeHours candidate ->
      ( { model |
            desiredHours = Field.hours candidate
        }
      , Cmd.none
      )

    ChangeMinutes candidate ->
      ( { model |
            desiredMinutes = Field.minutes candidate
        }
      , Cmd.none
      )

    ResetFields ->
      ( model |> makeFieldsEmpty
      , Cmd.none
      )

    StartDripping rate ->
      ( { model
          | droplet = Droplet.falls rate model.droplet
        }
      , Cmd.none
      )

    StartSimulation flowRate minutes ->
      ( { model
            | bagFluid = BagFluid.drains flowRate minutes model.bagFluid
        }
      , Cmd.none
      )
      
    Tick subMsg ->
      let
        (newDroplet, dropletCmd) =
          Animation.Messenger.update subMsg model.droplet
        (newFluid, fluidCmd) =
          Animation.Messenger.update subMsg model.bagFluid
      in
        ( { model
            | droplet = newDroplet
            , bagFluid = newFluid
          }
        , Cmd.batch [dropletCmd, fluidCmd]
        )


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
    , model.bagFluid
    ]

      
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

module IVFinal.IV exposing (..)

import Html exposing (..)
import Task


import IVFinal.Apparatus as Apparatus
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Apparatus.ChamberFluid as ChamberFluid
import IVFinal.Apparatus.HoseFluid as HoseFluid
import IVFinal.Form.InputFields as Field
import IVFinal.Scenario as Scenario exposing (Scenario)
import IVFinal.Simulation as Simulation
import IVFinal.Generic.Measures as Measure
import IVFinal.App.Animation as Animation
import IVFinal.App.Layout as Layout
import IVFinal.FormView as FormView
import IVFinal.Form.Types as Form
import Dom

import IVFinal.Types exposing (..)
import IVFinal.Simulation.Types exposing (..)

startingModel : Scenario -> Model
startingModel scenario =
  { scenario = scenario
  , stage = FormFilling

  , desiredDripRate = Field.dripRate ""
  , desiredMinutes = Field.minutes "0"
  , desiredHours = Field.hours "0"


  , droplet = Animation.style Droplet.initStyles
  , bagFluid = Animation.style <| BagFluid.initStyles <| Measure.proportion scenario.startingVolume scenario.containerVolume
  , chamberFluid = Animation.style ChamberFluid.initStyles
  , hoseFluid = Animation.style HoseFluid.initStyles
  }

init : (Model, Cmd Msg)
init = ( startingModel Scenario.carboy, Cmd.none )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    -- Form operations

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

    -- If the form is valid (expected) forward to simulation cases
      
    DrippingRequested ->
      normallyForward (Form.dripRate model) StartDripping model

    SimulationRequested ->
      normallyForward (Form.allValues model) StartSimulation model

    -- Running the simulation

    StartDripping rate ->
      ( Droplet.falls rate model
      , Cmd.none
      )

    StartSimulation finishedForm ->
      ( Simulation.run model.scenario finishedForm model
      , Cmd.none
      )

    RunContinuation (Continuation f) ->
      (f model, Cmd.none)
      
    Tick subMsg ->
      updateSimulations subMsg model

    -- After the simulation
        
    ResetSimulation ->
      ( startingModel model.scenario
      , Task.attempt
          (always SideEffectTaskFinished)
          (Dom.focus FormView.firstFocusId)
      )

    SideEffectTaskFinished ->
      ( model, Cmd.none ) 

updateSimulations : Animation.Msg -> Model -> (Model, Cmd Msg)
updateSimulations subMsg model =
  let
    (newDroplet, dropletCmd) =
      Animation.update subMsg model.droplet
    (newBagFluid, bagFluidCmd) =
      Animation.update subMsg model.bagFluid
    (newChamberFluid, chamberFluidCmd) =
      Animation.update subMsg model.chamberFluid
    (newHoseFluid, hoseFluidCmd) =
      Animation.update subMsg model.hoseFluid
  in
    ( { model
        | droplet = newDroplet
        , bagFluid = newBagFluid
        , chamberFluid = newChamberFluid
        , hoseFluid = newHoseFluid
      }
    , Cmd.batch [dropletCmd, bagFluidCmd, chamberFluidCmd, hoseFluidCmd]
    )

view : Model -> Html Msg
view model =
  Layout.wrapper 
    [ Layout.canvas <| Apparatus.view model
    , Layout.form <| FormView.view model
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Animation.subscription Tick
    [ model.droplet
    , model.bagFluid
    , model.chamberFluid
    , model.hoseFluid
    ]

      
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- Util

send : msg -> Cmd msg
send msg =
  Task.perform identity (Task.succeed msg)

maybeSend : (data -> msg) -> Maybe data -> Cmd msg
maybeSend constructor maybe =
  case maybe of
    Nothing ->
      Cmd.none
    Just value ->
      send (constructor value)

normallyForward : Maybe value -> (value -> msg) -> model
                -> (model, Cmd msg)        
normallyForward checked destinationCase model =
  ( model
  , maybeSend destinationCase checked
  )

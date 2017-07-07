module IVFinal.MAIN exposing (..)

import Html exposing (..)
import Task

import IVFinal.FormView as Form
import IVFinal.Form.Types as Form
import IVFinal.Form.InputFields as Field

import IVFinal.ApparatusView as Apparatus
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Apparatus.ChamberFluid as ChamberFluid
import IVFinal.Apparatus.HoseFluid as HoseFluid

import IVFinal.Scenario as Scenario exposing (Scenario)
import IVFinal.Simulation as Simulation
import IVFinal.Simulation.Types exposing (..)
import IVFinal.Types exposing (..)

import IVFinal.App.Animation as Animation
import IVFinal.App.Layout as Layout
import IVFinal.Generic.Measures as Measure

import Dom


startingModel : Scenario -> Model
startingModel scenario =
  let
    bagStartingPercent =
      Measure.proportion scenario.startingVolume scenario.containerVolume
  in
    { scenario = scenario
    , stage = FormFilling

    , desiredDripRate = Field.dripRate ""
    , desiredMinutes = Field.minutes "0"
    , desiredHours = Field.hours "0"

    , bagFluid = Animation.style <| BagFluid.initStyles bagStartingPercent
    , chamberFluid = Animation.style ChamberFluid.initStyles
    , hoseFluid = Animation.style HoseFluid.initStyles
    , droplet = Animation.style Droplet.initStyles
  }

init : (Model, Cmd Msg)
init = ( startingModel Scenario.carboy
       , Cmd.none
       )

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

    -- If the form is valid, forward to simulation cases
    DrippingRequested ->
      normallyForward (Form.dripRate model) StartDripping model

    SimulationRequested ->
      normallyForward (Form.allValues model) StartSimulation model

    -- Running the simulation

    StartDripping rate ->
      ( Droplet.dripsOrStreams rate model
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
          (Dom.focus Form.firstFocusId)
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
    , Layout.form <| Form.view model
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

{- Cause a message to be delivered. A roundabout way of calling what
could just be another function. Done this way to show how a program can
create its own special-purpose commands.
-} 
forward : msg -> Cmd msg
forward msg =
  Task.perform identity (Task.succeed msg)

{- Return an unchanged `Model` and a `Cmd` that sends a `Msg` to a
later invocation of `update`.

Takes a value wrapped in a `Maybe`. It should be "impossible" for
that to be `Nothing`. If the impossible happens, nothing is done.

Otherwise, the given function is used to make a `Cmd` that delivers a `Msg`. 
-}
normallyForward : Maybe value -> (value -> msg) -> model
                -> (model, Cmd msg)        
normallyForward maybe msgMaker model =
  case maybe of
    Nothing ->
      (model, Cmd.none)
    Just value ->
      (model, forward (msgMaker value))

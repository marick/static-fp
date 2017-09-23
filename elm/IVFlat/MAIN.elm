module IVFlat.MAIN exposing (..)

import Html exposing (..)
import Task

import IVFlat.FormView as Form
import IVFlat.Form.Types as Form
import IVFlat.Form.Validators as Validated

import IVFlat.ApparatusView as Apparatus
import IVFlat.Apparatus.Droplet as Droplet
import IVFlat.Apparatus.BagFluid as BagFluid
import IVFlat.Apparatus.ChamberFluid as ChamberFluid
import IVFlat.Apparatus.HoseFluid as HoseFluid

import IVFlat.Scenario as Scenario exposing (Scenario)
import IVFlat.Simulation as Simulation
import IVFlat.Simulation.Types exposing (..)
import IVFlat.Types exposing (..)

import IVFlat.App.Animation as Animation
import IVFlat.App.Layout as Layout
import IVFlat.Generic.Measures as Measure
import IVFlat.Generic.Cmd as Cmd
import IVFlat.Generic.Lens as Lens exposing (Lens, lens)

import Dom


startingModel : Scenario -> Model
startingModel scenario =
  let
    bagStartingPercent =
      Measure.proportion scenario.startingVolume scenario.containerVolume
  in
    { scenario = scenario
    , stage = FormFilling

    , desiredDripRate = Validated.dripRate ""
    , desiredMinutes = Validated.minutes "0"
    , desiredHours = Validated.hours "0"

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
            desiredDripRate = Validated.dripRate candidate
        }
      , Cmd.none
      )

    ChangeHours candidate ->
      ( { model |
            desiredHours = Validated.hours candidate
        }
      , Cmd.none
      )

    ChangeMinutes candidate ->
      ( { model |
            desiredMinutes = Validated.minutes candidate
        }
      , Cmd.none
      )

    -- If the form is valid, forward to animation cases
    DrippingRequested ->
      ( model
      , whenValid StartDripping (Form.dripRate model)
      )

    SimulationRequested ->
      ( model
      , whenValid StartSimulation (Form.allValues model)
      )

    -- Running animations
    StartDripping rate ->
      ( Droplet.dripsOrStreams rate model
      , Cmd.none
      )

    StartSimulation finishedForm ->
      ( Simulation.run model.scenario finishedForm model
      , Cmd.none
      )

    RunContinuation (Next next) ->
      (next model, Cmd.none)
      
    Tick subMsg ->
      updateMyAnimations2 subMsg model

        
    -- After the simulation
        
    ResetSimulation ->
      ( startingModel model.scenario
      , Task.attempt
          (always SideEffectTaskFinished)
          (Dom.focus Form.firstFocusId)
      )

    SideEffectTaskFinished ->
      ( model, Cmd.none ) 

updateMyAnimations : Animation.Msg -> Model -> (Model, Cmd Msg)
updateMyAnimations subMsg model =
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

-- An alternate version of `updateAnimations`
updateMyAnimations2 : Animation.Msg -> Model -> (Model, Cmd Msg)
updateMyAnimations2 subMsg model =
  Animation.updateAnimations subMsg model 
    [ lens .droplet       (\new model -> { model | droplet = new})
    , lens .bagFluid      (\new model -> { model | bagFluid = new})
    , lens .chamberFluid  (\new model -> { model | chamberFluid = new})
    , lens .hoseFluid     (\new model -> { model | hoseFluid = new})
    ]

      
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

whenValid : (value -> msg) -> Maybe value -> Cmd msg
whenValid toMsg maybe =
  case maybe of
    Nothing ->
      Cmd.none
    Just value ->
      Cmd.wrap toMsg value

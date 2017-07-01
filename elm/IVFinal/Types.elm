module IVFinal.Types exposing (..)

import IVFinal.App.InputFields as Field
import Animation.Messenger
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (Scenario)
import IVFinal.Simulation.Types as Simulation
import Animation

type alias AnimationModel = Animation.Messenger.State Msg
type alias AnimationStep = Animation.Messenger.Step Msg

type alias Model =
  { scenario : Scenario
  , stage : Simulation.Stage

  , desiredDripRate : Field.DripRate
  , desiredMinutes : Field.Minutes
  , desiredHours : Field.Hours
      
  , droplet : AnimationModel
  , bagFluid : AnimationModel
  }

  
type Continuation = Continuation (Model -> Model)
type alias ModelTransform = Model -> Model
  

type alias FinishedForm = 
  { dripRate : Measure.DropsPerSecond
  , hours : Measure.Hours
  , minutes : Measure.Minutes
  }


type Msg
  = ChangeDripRate String
  | ChangeHours String
  | ChangeMinutes String
  | ResetSimulation

  | DrippingRequested
  | StartDripping Measure.DropsPerSecond

  | SimulationRequested
  | StartSimulation FinishedForm

  | Tick Animation.Msg
  | RunContinuation Continuation

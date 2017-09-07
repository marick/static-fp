module IVFlat.Types exposing
  ( Model
  , Msg(..)
  , Continuation(..)
  , ModelTransform
  , AnimationModel
  )

{- Mainly the `Model` and `Msg` types, collected in this one
model to avoid circular dependencies.
-}

import IVFlat.Generic.ValidatedString exposing (ValidatedString)
import IVFlat.Scenario exposing (Scenario)
import IVFlat.Simulation.Types as Simulation
import IVFlat.Form.Types exposing (FinishedForm)
import IVFlat.Generic.Measures as Measure
import Animation.Messenger
import Animation


-- This needs to be here to avoid circular dependencies.
-- Elsewhere, use App.Animation.Model
type alias AnimationModel = Animation.Messenger.State Msg

{- A flat Model used by the whole app 
-}  
type alias Model =
  { scenario : Scenario
  , stage : Simulation.Stage

  , desiredDripRate : ValidatedString Measure.DropsPerSecond
  , desiredMinutes :  ValidatedString Measure.Minutes
  , desiredHours :    ValidatedString Measure.Hours
      
  , droplet :      AnimationModel
  , bagFluid :     AnimationModel
  , chamberFluid : AnimationModel
  , hoseFluid :    AnimationModel
  }

{- Varous animation functions are most conveniently thought of as
transformers for models, and are defined in point-free style. This
alias labels them for easy recognition.
-}
type alias ModelTransform = Model -> Model

{- Single-level `Msg` type. 
-}

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

  -- Use this for tasks that produce no useful values, and
  -- when we don't even care whether is succeeded or not.
  | SideEffectTaskFinished


{- Parts of the app use continuation-passing style. The continuations
are tagged with this type to make their purpose more clear.

This has to be defined here to avoid circular model dependencies.
-}
type Continuation = Continuation (Model -> Model)



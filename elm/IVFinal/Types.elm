module IVFinal.Types exposing
  ( Model
  , Msg
  , Continuation
  , FinishedForm
  , ModelTransform
  )

{-| Mainly the `Model` and `Msg` types, collected in this one
model to avoid circular dependencies.

# The Big Two
@docs Model, Msg

# Others
@docs FinishedForm, ModelTransform, Continuation
-}

import IVFinal.Scenario exposing (Scenario)
import IVFinal.Simulation.Types as Simulation
import IVFinal.App.InputFields as Field
import IVFinal.Generic.Measures as Measure
import Animation.Messenger
import Animation


-- This needs to be here to avoid circular dependencies.
-- Elsewhere, use App.Animation.Model
type alias AnimationModel = Animation.Messenger.State Msg

{-| A flat Model used by the whole app 
-}  
type alias Model =
  { scenario : Scenario
  , stage : Simulation.Stage

  , desiredDripRate : Field.DripRate
  , desiredMinutes : Field.Minutes
  , desiredHours : Field.Hours
      
  , droplet : AnimationModel
  , bagFluid : AnimationModel
  , chamberFluid : AnimationModel
  , hoseFluid : AnimationModel
  }

{-| When all the `Field` values exist and are valid, they can
be extracted to this structure, which can then be used for
processing without worrying about `Maybe`. 
-}
type alias FinishedForm = 
  { dripRate : Measure.DropsPerSecond
  , hours : Measure.Hours
  , minutes : Measure.Minutes
  }

{-| Single-level `Msg` type. 
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


{-| Parts of the app use continuation-passing style. The continuations
are tagged with this type to make their purpose more clear.
-}
type Continuation = Continuation (Model -> Model)


{-| Varous animation functions are most conveniently thought of as
transformers for models, and are defined in point-free style. This
alias labels them for easy recognition.
-}
type alias ModelTransform = Model -> Model

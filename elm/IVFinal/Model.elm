module IVFinal.Model exposing (..)

import IVFinal.View.InputFields as Field
import Animation.Messenger
import IVFinal.Measures as Measure
import IVFinal.Scenario exposing (Scenario)
import IVFinal.Msg exposing (..)

type alias AnimationModel = Animation.Messenger.State Msg

type SimulationStage
  = FormFilling
  | WatchingAnimation Measure.LitersPerMinute  -- drain rate
  | Finished Measure.Liters -- ending state

type alias Model =
  { scenario : Scenario
  , stage : SimulationStage

  , desiredDripRate : Field.DripRate
  , desiredMinutes : Field.Minutes
  , desiredHours : Field.Hours
      
  , droplet : AnimationModel
  , bagFluid : AnimationModel
  }

type alias FormData r =
  { r
    | desiredDripRate : Field.DripRate
    , desiredHours : Field.Hours
    , desiredMinutes : Field.Minutes
    , stage : SimulationStage
  }

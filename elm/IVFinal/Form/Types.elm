module IVFinal.Form.Types exposing
  ( FinishedForm
    
  , dripRate
  , allValues
  , isFormIncomplete
  )

import IVFinal.Form.InputFields as Field
import Tagged exposing (Tagged(Tagged))
import IVFinal.Generic.Measures as Measure

type alias JustFields model =
  { model
    | desiredDripRate : Field.DripRate
    , desiredHours : Field.Hours
    , desiredMinutes : Field.Minutes
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


    
dripRate : JustFields model -> Maybe Measure.DropsPerSecond
dripRate model =
  model.desiredDripRate.value           

allValues : JustFields model -> Maybe FinishedForm
allValues model =
  Maybe.map3 FinishedForm
    model.desiredDripRate.value
    model.desiredHours.value
    model.desiredMinutes.value

isFormIncomplete : JustFields model -> Bool      
isFormIncomplete model =
  let
    runtime {hours, minutes} =
      Measure.toMinutes hours minutes
  in
    case allValues model |> Maybe.map runtime of
      Nothing -> True
      Just (Tagged 0) -> True
      _ -> False


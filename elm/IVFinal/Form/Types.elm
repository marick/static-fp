module IVFinal.Form.Types exposing
  ( FinishedForm
    
  , dripRate
  , allValues
  , isFormIncomplete

  -- exposed only for testing
  , JustFields
  )

{-| Types and simplish accessors related to the content of the form. 
-}

import IVFinal.Generic.Measures as Measure
import IVFinal.Form.InputFields as Field
import Tagged exposing (Tagged(Tagged))
import Maybe.Extra as Maybe

{- Similar to the `Obscured` types elsewhere, this describes those
`Model` fields code here can see. Private.
-}
type alias JustFields model =
  { model
    | desiredDripRate : Field.DripRate
    , desiredHours : Field.Hours
    , desiredMinutes : Field.Minutes
  }

{-| When all the `Field` values exist and are valid, they can
be extracted to this structure. Client code therefore needn't worry
about how the fields have `Maybe` values.
-}
type alias FinishedForm = 
  { dripRate : Measure.DropsPerSecond
  , hours : Measure.Hours
  , minutes : Measure.Minutes
  }

{-| Extract just the `dripRate` field's value (which can be used before
the other fields are complete.
-}
dripRate : JustFields model -> Maybe Measure.DropsPerSecond
dripRate model =
  model.desiredDripRate.value           

{-| Convert fields with `Maybe` values into a single `Maybe
FinishedForm` value.

Cross-field validations *are* performed. For example, the result will
be `Nothing` if both the `hours` and `minutes` fields are zero.

Note I'm relying on an the fact that every type alias (like `FinishedForm`) 
for a record also creates a value constructor whose arguments
are in the same order as the fields are listed in the record. That's
iffy in general, since rearranging a record can break uses of the
constructor. However, it's safe in this case because each field has a
different type.
-}

allValues : JustFields model -> Maybe FinishedForm
allValues model =
  let
    extraction =
      Maybe.map3 FinishedForm
        model.desiredDripRate.value
        model.desiredHours.value
        model.desiredMinutes.value
  in
    extraction 
      |> Maybe.andThen crossFieldValidations

{- Reject an (ostensibly) `FinishedForm` if both the hours and minutes
are zero
-}
crossFieldValidations : FinishedForm -> Maybe FinishedForm
crossFieldValidations model  = 
  case Measure.toMinutes model.hours model.minutes of
    (Tagged 0) -> Nothing
    _ -> Just model

{-| True if either per-field or cross-field validations fail. 
-}             
isFormIncomplete : JustFields model -> Bool      
isFormIncomplete model =
  allValues model |> Maybe.isNothing

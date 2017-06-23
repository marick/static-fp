module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.View.AppHtml as H

import IVFinal.Types exposing (..)
import Maybe.Extra as Maybe
import IVFinal.Measures as Measure
import Tagged exposing (Tagged(..))

drainMinutes : FormData a -> Maybe (Measure.Minutes)
drainMinutes {desiredHours, desiredMinutes} =
  let
    bigEnough (Tagged i) = i > 0
  in
    Maybe.map2 Measure.toMinutes desiredHours.value desiredMinutes.value
      |> Maybe.filter bigEnough

isFormReady : FormData a -> Bool
isFormReady formData =
  case (formData.desiredDripRate.value, drainMinutes formData) of
    (Just _, Just _) -> True
    _ -> False

startButtonBehavior : msg -> FormData a -> Maybe msg      
startButtonBehavior msg formData =
  case isFormReady formData of
    True -> Just msg
    False -> Nothing

view : FormData a -> List (Html Msg)
view formData = 
  [ div []
      [ H.askFor "Drops per second" formData.desiredDripRate
          [ Event.onInput ChangeDripRate
          , Event.onBlur StartDripping
          ]
      , H.br
      , H.askFor "Hours" formData.desiredHours
          [Event.onInput ChangeHours]
      , text " and minutes: "
      , H.textInput formData.desiredMinutes
          [Event.onInput ChangeMinutes]
      , H.br
      , H.br
      , H.button "Start" (startButtonBehavior StartSimulation formData)
      , H.button "Reset Fields" (Just ResetFields)
      ]
  ]
  

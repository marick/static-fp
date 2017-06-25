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

alwaysAllow f c = Just (f c)
              
events = Maybe.values

whenReady value f2 f1 =
  case value of
    Just v ->
      v |> f1 |> f2 |> Just
    _ ->
      Nothing

whenReady2 (value1, value2) f2 f1 =
  case (value1, value2) of
    (Just v1, Just v2) ->
      f1 v1 v2 |> f2 |> Just
    _ ->
      Nothing
      
         
view : FormData a -> List (Html Msg)
view formData =
  let 
    dripRateEvents =
      events
      [ alwaysAllow
          Event.onInput ChangeDripRate
      , whenReady formData.desiredDripRate.value
          Event.onBlur StartDripping
      ]
    startButtonEvents =
      events
      [ whenReady2
          ( Maybe.map Measure.flowRate 
              formData.desiredDripRate.value
          , Maybe.map2 Measure.toMinutes
              formData.desiredHours.value
              formData.desiredMinutes.value
          )
          Event.onClick StartSimulation
      ]
  in 
    [ div []
        [ H.askFor "Drops per second" formData.desiredDripRate dripRateEvents
        , H.br
        , H.askFor "Hours" formData.desiredHours
          [Event.onInput ChangeHours]
        , text " and minutes: "
        , H.textInput formData.desiredMinutes
          [Event.onInput ChangeMinutes]
        , H.br
        , H.br
        , H.button2 "Start" startButtonEvents
        , H.button "Reset Fields" (Just ResetFields)
        ]
    ]

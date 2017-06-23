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

isFormReady : Model -> Bool
isFormReady model =
  case (model.desiredDripRate.value, drainMinutes model) of
    (Just _, Just _) -> True
    _ -> False

startButtonBehavior : msg -> Model -> Maybe msg      
startButtonBehavior msg model =
  case isFormReady model of
    True -> Just msg
    False -> Nothing

view : Model -> List (Html Msg)
view model = 
  [ div []
      [ H.askFor "Drops per second" model.desiredDripRate
          [ Event.onInput ChangeDripRate
          , Event.onBlur StartDripping
          ]
      , H.br
      , H.askFor "Hours" model.desiredHours
          [Event.onInput ChangeHours]
      , text " and minutes: "
      , H.textInput model.desiredMinutes
          [Event.onInput ChangeMinutes]
      , H.br
      , H.br
      , H.button "Start" (startButtonBehavior StartSimulation model)
      , H.button "Reset Fields" (Just ResetFields)
      ]
  ]
  

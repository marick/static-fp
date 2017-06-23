module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.View.AppHtml as H

import IVFinal.Types exposing (..)
import Maybe.Extra as Maybe


isFormReady : Model -> Bool
isFormReady model =
  let
    validDripRate = Maybe.isJust model.desiredDripRate.value
  in
    validDripRate

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
      , H.askFor "Hours" model.desiredDripRate
          [Event.onInput ChangeHours]
      , text " and minutes: "
      , H.textInput model.desiredDripRate
          [Event.onInput ChangeMinutes]
      , H.br
      , H.br
      , H.button "Start" (startButtonBehavior StartSimulation model)
      , H.button "Reset Fields" (Just ResetFields)
      ]
  ]
  

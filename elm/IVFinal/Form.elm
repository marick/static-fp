module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.View.AppHtml as H

import IVFinal.Types exposing (..)

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
      , H.button "Start" StartSimulation
      , H.button "Reset Fields" ResetFields
      ]
  ]
  

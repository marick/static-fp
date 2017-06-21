module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.View.AppHtml as H

import Tagged exposing (Tagged(..))
import IVFinal.Types exposing (..)

view : Model -> List (Html Msg)
view model = 
  [ div []
      [ H.askFor "Drops per second" model.desiredDripRate
          [Event.onInput ChangeDripRate]
      , H.br
      , H.askFor "Hours" model.desiredDripRate
          [Event.onInput ChangeDripRate]
      , text " and minutes: "
      , H.textInput model.desiredDripRate
          [Event.onInput ChangeDripRate]
      , H.br
      , H.br
      , H.button "Start" Click
      , H.button "Reset" Click
      ]
  ]
  

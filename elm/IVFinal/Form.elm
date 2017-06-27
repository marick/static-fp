module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Events as Event
import IVFinal.View.AppHtml as H

import IVFinal.Msg exposing (..)
import IVFinal.Model exposing (..)
import Tagged exposing (Tagged(..))


unwrap3 : (Maybe a, Maybe b, Maybe c) -> Maybe (a, b, c)
unwrap3 tuple =
  case tuple of
    (Just a, Just b, Just c) -> Just (a, b, c)
    _ -> Nothing

isFormReady : FormData a -> Bool
isFormReady formData =
  let
    fields = ( formData.desiredDripRate.value
             , formData.desiredMinutes.value
             , formData.desiredHours.value
             )
  in
    case unwrap3 fields of
      Nothing ->
        False
      Just (_, Tagged minutes, Tagged hours) ->
        minutes /= 0 || hours /= 0


view : FormData a -> List (Html Msg)
view formData =
  let 
    dripRateFieldEvents =
      [ Event.onInput ChangeDripRate
      , Event.onBlur DrippingRequested
      ]
      
    startButtonEvents =
      [ Event.onClick SimulationRequested ]
        
    hourFieldEvents =
      [ Event.onInput ChangeHours ]

    minuteFieldEvents = 
      [Event.onInput ChangeMinutes]
  in 
    [ div []
        [ H.askFor "Drops per second"
            formData.desiredDripRate
            dripRateFieldEvents
        , H.br
        , H.askFor "Hours" formData.desiredHours hourFieldEvents
        , text " and minutes: "
        , H.textInput formData.desiredMinutes minuteFieldEvents
        , H.br
        , H.br
        , H.button2 "Start" startButtonEvents
        , H.button "Try Again" (Just ResetSimulation)
        ]
    ]

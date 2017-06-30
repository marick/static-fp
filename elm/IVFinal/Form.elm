module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.App.Html as H
import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(..), untag)

import IVFinal.Types exposing (..)

view : FormData a -> List (Html Msg)
view formData =
  case formData.stage of
    FormFilling ->
      fillingView formData
    WatchingAnimation flowRate ->
      watchingView formData flowRate
    Finished flowRate litersDrained ->
      finishedView formData flowRate litersDrained
  
type alias InputAttributes =
  { dripRateAttrs : List (Attribute Msg)
  , hourAttrs : List (Attribute Msg)
  , minuteAttrs : List (Attribute Msg)
  }

disabled : List (Html msg) -> List (Html msg)
disabled contents =
  [ div [ style [ ("pointer-events", "none")
              , ("opacity", "0.7")
              ]
      ]
    contents
  ]
  
baseView : FormData a -> InputAttributes -> List (Html Msg)
baseView {scenario, desiredDripRate, desiredHours, desiredMinutes}
         {dripRateAttrs, hourAttrs, minuteAttrs} =
  let
    {startingFluid, containerVolume, animal, bagType} = scenario
    s (Tagged value) = toString value
  in
    [ p []
      [ text <| "You are presented with " ++ animal ++ ". "
      , text <| "You have " ++ s startingFluid ++ " liters of fluid in a "
      , text <| bagType ++ " that holds " ++ s containerVolume ++ " liters."
      ]
    , p []
      [ text <| "Using your calculations, set the drip rate to "
      , H.textInput desiredDripRate dripRateAttrs
      , text <| " drops/sec, then set the hours "
      , H.textInput desiredHours hourAttrs
      , text <| " and minutes "
      , H.textInput desiredMinutes minuteAttrs
      , text <| " until you plan to next look at the fluid level."
      ]
    ]
  

fillingView : FormData a -> List (Html Msg)
fillingView formData =
  baseView formData
    { dripRateAttrs =
        [ Event.onInput ChangeDripRate
        , Event.onBlur DrippingRequested
        , autofocus True
        ]
    , hourAttrs =
        [ Event.onInput ChangeHours ]
    , minuteAttrs =
        [Event.onInput ChangeMinutes]
    }
    ++
    [ H.soloButton "Start" 
        [ Event.onClick SimulationRequested ]
    ]
      
staticView : FormData r -> List (Html Msg)
staticView formData =
  disabled <| baseView formData
    { dripRateAttrs = [ readonly True ]
    , hourAttrs = [ readonly True ]
    , minuteAttrs = [ readonly True ]
    }

watchingView : FormData r -> Measure.LitersPerMinute -> List (Html Msg)
watchingView formData rate =
  let
    -- Put text below where cursor is now.
    spacer = List.repeat 3 (br [] []) 
  in
    (disabled <| staticView formData)
    ++ spacer
    ++ describeFlow "is" rate
    
finishedView : FormData r -> Measure.LitersPerMinute -> Measure.Liters -> List (Html Msg)
finishedView formData flowRate (Tagged drained) =
  (disabled <| staticView formData)
  ++ [ H.soloButton "Try Again With New Values"
         [ Event.onClick ResetSimulation ]
     ]
  ++ describeFlow "was" flowRate
  ++ [br [] []]
  ++ ("The final level is " ++ toString drained ++ " liters."
       |> strongSentence)
     
  
--- Util

strongSentence : String -> List (Html msg)
strongSentence s = 
  [ strong [] [ text s ] ]

describeFlow : String -> Measure.LitersPerMinute -> List (Html msg)
describeFlow pronoun (Tagged rate) =
  let
    show = toString (rate * 60)
  in
    "The flow rate " ++ pronoun ++ " " ++ show ++ " liters/hour."
      |> strongSentence
    

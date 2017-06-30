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
      [ fillingView formData ]
    WatchingAnimation flowRate ->
      [ watchingView formData flowRate ] 
    Finished flowRate litersDrained ->
      [ finishedView formData flowRate litersDrained ]
  
baseView : FormData a -> InputAttributes -> Html Msg
baseView {scenario, desiredDripRate, desiredHours, desiredMinutes}
         {dripRateAttrs, hourAttrs, minuteAttrs} =
  let
    {startingFluid, containerVolume, animal, bagType} =
      scenario

    s (Tagged value) =
      toString value

    para1 =
      p []
        [ text <| "You are presented with " ++ animal ++ ". "
        , text <| "You have " ++ s startingFluid ++ " liters of fluid in a "
        , text <| bagType ++ " that holds " ++ s containerVolume ++ " liters."
        ]

    para2 =
      p []
        [ text <| "Using your calculations, set the drip rate to "
        , H.textInput desiredDripRate dripRateAttrs
        , text <| " drops/sec, then set the hours "
        , H.textInput desiredHours hourAttrs
        , text <| " and minutes "
        , H.textInput desiredMinutes minuteAttrs
        , text <| " until you plan to next look at the fluid level."
        ]
  in
    div [] 
      [ para1, para2 ] 

fillingView : FormData a -> Html Msg
fillingView formData =
  let
    formReadyAttributes = 
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
  in
    div []
      [ baseView formData formReadyAttributes
      , H.soloButton "Start" 
        [ Event.onClick SimulationRequested ]
      ]
      
staticView : FormData r -> Html Msg
staticView formData =
  div []
    [ disabled <| baseView formData
        { dripRateAttrs = [ readonly True ]
        , hourAttrs = [ readonly True ]
        , minuteAttrs = [ readonly True ]
        }
    ]

watchingView : FormData r -> Measure.LitersPerMinute -> Html Msg
watchingView formData rate =
  let
    -- Put text below where cursor is now.
    spacer = span [] (List.repeat 3 (br [] []))
  in
    div []
      [ staticView formData
      , spacer
      , describeFlow "is" rate
      ]
    
finishedView : FormData r -> Measure.LitersPerMinute -> Measure.Liters -> Html Msg
finishedView formData flowRate (Tagged drained) =
  div []
    [ staticView formData
    , H.soloButton "Try Again With New Values"
      [ Event.onClick ResetSimulation ]
    , describeFlow "was" flowRate
    ,   ("The final level is " ++ toString drained ++ " liters."
        |> strongSentence)
    ]
  
--- Util


type alias InputAttributes =
  { dripRateAttrs : List (Attribute Msg)
  , hourAttrs : List (Attribute Msg)
  , minuteAttrs : List (Attribute Msg)
  }



strongSentence : String -> Html msg
strongSentence s = 
  span []
    [ strong [] [ text s ]
    , br [] []
    ]

describeFlow : String -> Measure.LitersPerMinute -> Html msg
describeFlow pronoun (Tagged rate) =
  let
    show = toString (rate * 60)
  in
    "The flow rate " ++ pronoun ++ " " ++ show ++ " liters/hour."
      |> strongSentence
    
disabled : Html msg -> Html msg
disabled tree =
  div [ style [ ("pointer-events", "none")
              , ("opacity", "0.6")
              ]
      ]
  [ tree ]
  

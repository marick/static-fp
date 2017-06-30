module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.App.Html as H
import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(..), untag)
import IVFinal.Simulation.Types as Simulation exposing (Stage(..))

import IVFinal.Types exposing (..)

view : FormData a -> List (Html Msg)
view formData =
  case formData.stage of
    FormFilling ->
      [ baseView formData formCanBeChanged
      , startButton
      ]
      
    WatchingAnimation flowRate ->
      [ baseView formData formIsDisabled
      , verticalSpace -- so following text is below the cursor.
      , describeFlow "is" flowRate
      ]

    Finished flowRate howFinished ->
      let 
        common flowRate = 
          [ baseView formData formIsDisabled
          , tryAgainButton
          , describeFlow "was" flowRate
          ]
      in
        case howFinished of
          Simulation.FluidLeft {finalLevel} ->
            common flowRate
              ++ [ describeFinalLevel finalLevel
                 ]

  
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

  
--- Attributes

type alias InputAttributes =
  { dripRateAttrs : List (Attribute Msg)
  , hourAttrs : List (Attribute Msg)
  , minuteAttrs : List (Attribute Msg)
  }

formCanBeChanged : InputAttributes
formCanBeChanged = 
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

formIsDisabled : InputAttributes
formIsDisabled = 
  let
    disabled = style [ ("pointer-events", "none")
                     , ("opacity", "0.6")
                     ]
  in
    { dripRateAttrs = [disabled]
    , hourAttrs = [disabled]
    , minuteAttrs = [disabled]
    }

-- Buttons

startButton : Html Msg
startButton = 
  H.soloButton "Start" 
    [ Event.onClick SimulationRequested ]


tryAgainButton : Html Msg
tryAgainButton = 
  H.soloButton "Try Again With New Values"
    [ Event.onClick ResetSimulation ]


-- Bits of message
    
describeFlow : String -> Measure.LitersPerMinute -> Html msg
describeFlow pronoun (Tagged rate) =
  let
    show = toString (rate * 60)
  in
    "The flow rate " ++ pronoun ++ " " ++ show ++ " liters/hour."
      |> strongSentence

describeFinalLevel : Measure.Liters -> Html msg
describeFinalLevel (Tagged litersLeft) =
  "The final level is " ++ toString litersLeft ++ " liters."
    |> strongSentence


-- Misc
         
verticalSpace : Html msg
verticalSpace = span [] (List.repeat 3 (br [] []))

                

strongSentence : String -> Html msg
strongSentence s = 
  span []
    [ strong [] [ text s ]
    , br [] []
    ]

        

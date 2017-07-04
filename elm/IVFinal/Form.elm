module IVFinal.Form exposing
  ( view
  , allValues
  , dripRate

  , firstFocusId
  )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.App.Html as H
import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(Tagged))
import IVFinal.Simulation.Types as Simulation exposing (Stage(..))
import IVFinal.App.InputFields as Field
import IVFinal.Scenario exposing (Scenario)
import Maybe.Extra as Maybe
import Round

import IVFinal.Types exposing (Msg(..), FinishedForm)

{- 
   Note that there may be only one form on a page. This is not
   *quite* an isolated component. (See use of `firstFocusId`.)
-}

type alias Obscured model =
  { model
    | desiredDripRate : Field.DripRate
    , desiredHours : Field.Hours
    , desiredMinutes : Field.Minutes
    , stage : Simulation.Stage
    , scenario : Scenario
  }

dripRate : Obscured model -> Maybe Measure.DropsPerSecond
dripRate model =
  model.desiredDripRate.value           

allValues : Obscured model -> Maybe FinishedForm
allValues model =
  Maybe.map3 FinishedForm
    model.desiredDripRate.value
    model.desiredHours.value
    model.desiredMinutes.value

isFormReady model =
  let
    runtime {hours, minutes} =
      Measure.toMinutes hours minutes
  in
    allValues model
      |> Maybe.map runtime
      |> Maybe.map Measure.isStrictlyPositive
      

view : Obscured model -> List (Html Msg)
view model =
  case model.stage of
    FormFilling ->
      [ baseView model formCanBeChanged
      , startButton model
      ]
      
    WatchingAnimation flowRate ->
      [ baseView model formIsDisabled
      , verticalSpace -- so following text is below the cursor.
      , describeFlow "is" flowRate
      ]

    Finished flowRate howFinished ->
      let 
        common flowRate = 
          [ baseView model formIsDisabled
          , tryAgainButton
          , describeFlow "was" flowRate
          ]

        variant =
          case howFinished of
            Simulation.FluidLeft endingVolume ->
              [ describeFinalLevel endingVolume ]
            Simulation.RanOutAfter minutes ->
              [ describeOverflow minutes ]
      in
        common flowRate ++ variant

-- Note that this prevents having more than one form on a page.
firstFocusId : String          
firstFocusId = "focusGoesHere"
          
baseView : Obscured model -> InputAttributes -> Html Msg
baseView {scenario, desiredDripRate, desiredHours, desiredMinutes}
         {dripRateAttrs, hourAttrs, minuteAttrs} =
  let
    {startingVolume, containerVolume, animal, bagType} =
      scenario

    s (Tagged value) =
      toString value

    para1 =
      p []
        [ text <| "You are presented with " ++ animal ++ ". "
        , text <| "You have " ++ s startingVolume ++ " liters of fluid in a "
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
      , autofocus True  -- sets focus on page load.
      , id firstFocusId -- reset focus after `tryAgainButton`
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

startButton : Obscured model -> Html Msg
startButton model = 
  H.soloButton "Start" 
    [ Event.onClick SimulationRequested
    , disabled (allValues model |> Maybe.isNothing)
    ]

tryAgainButton : Html Msg
tryAgainButton = 
  H.soloButton "Try Again With New Values"
    [ Event.onClick ResetSimulation ]


-- Bits of message
    
describeFlow : String -> Measure.LitersPerMinute -> Html msg
describeFlow pronoun (Tagged rate) =
  let
    show = format (rate * 60) "liter"
  in
    "The flow rate " ++ pronoun ++ " " ++ show ++ "/hour."
      |> strongSentence

describeFinalLevel : Measure.Liters -> Html msg
describeFinalLevel (Tagged litersLeft) =
  let
    show = format litersLeft "liter"
  in
    strongSentence <| "The final level is " ++ show ++ "."

describeOverflow : Measure.Minutes -> Html msg
describeOverflow minutes =
  let
    show = Measure.friendlyMinutes minutes
  in
    alert <| "The fluid ran out after " ++ show ++ "."

-- Misc
         
verticalSpace : Html msg
verticalSpace = span [] (List.repeat 3 (br [] []))

strongSentence : String -> Html msg
strongSentence s = 
  span []
    [ strong [] [ text s ]
    , br [] []
    ]

alert : String -> Html msg
alert s =
  span []
    [ strong [style [("color", "red")]]
        [text s]
    , br [] []
    ]

    
format : Float -> String -> String
format n singular =
  let
    suffix =
      if n == 1 then
        singular
      else
        singular ++ "s"
    number =
      Round.round 2 n
  in
    number ++ " " ++ suffix

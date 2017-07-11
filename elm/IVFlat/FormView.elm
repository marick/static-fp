module IVFlat.FormView exposing
  ( view
  , firstFocusId
  )

{- Calculating the form that lives on the right-hand side of the page.

**NOTE**: There may only be one form on the page at a time. (See the use
of `firstFocusId`.
-}                                                              

import IVFlat.Form.Types as Form exposing (isFormIncomplete)
import IVFlat.Simulation.Types as Simulation exposing (Stage(..))
import IVFlat.Scenario exposing (Scenario)

import IVFlat.Generic.ValidatedString exposing (ValidatedString)
import IVFlat.Generic.Measures as Measure
import IVFlat.App.Html as H
import IVFlat.Types exposing (Msg(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Tagged exposing (Tagged(Tagged))
import Round

{- The top-level `Model` fields this module is allowed to look at. Private.
-}
type alias Obscured model =
  { model
    | desiredDripRate : ValidatedString Measure.DropsPerSecond
    , desiredHours :    ValidatedString Measure.Hours
    , desiredMinutes :  ValidatedString Measure.Minutes

    , stage : Simulation.Stage
    , scenario : Scenario
  }

{- Convert the Model into part of an `Html Msg`
-}
view : Obscured model -> List (Html Msg)
view model =
  case model.stage of
    FormFilling ->
      [ formProper model formCanBeChanged
      , startButton model
      ]
      
    WatchingAnimation flowRate ->
      [ formProper model formIsDisabled
      , verticalSpace -- so following text is below the cursor.
      , describeFlow "is" flowRate
      ]

    Finished flowRate howFinished ->
      let 
        common flowRate = 
          [ formProper model formIsDisabled
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

{- The drip rate field has autofocus set on it. However, we also need
to set the focus explicitly when the `Restart` button is pressed. That
means we need an `id` attribute.

Note that this prevents having more than one form on a page.
-}
firstFocusId : String          
firstFocusId = "focusGoesHere"

{- Everything above the buttons and commentary on the choices.
-}
formProper : Obscured model -> InputAttributes -> Html Msg
formProper {scenario, desiredDripRate, desiredHours, desiredMinutes}
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
        [ text """
                Using the numbers given you by your instructor,
                find an appropriate drip rate and time to administer.
               """
        ]

    para3 =
      p []
        [ text <| "Check if the ending fluid level is what you expected by setting the drip rate to "
        , H.textInput desiredDripRate dripRateAttrs
        , text <| " drops/sec, then setting the hours "
        , H.textInput desiredHours hourAttrs
        , text <| " and minutes "
        , H.textInput desiredMinutes minuteAttrs
        , text <| ", then clicking Start."
        ]
  in
    div [] 
      [ para1, para2, para3 ] 

  
--- Attributes

{- Depending on the state of the form, buttons are disabled, input
fields are specially colored, etc. This type describes the appropriate
per-state attributes
-}
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
    , disabled (isFormIncomplete model)
    ]

tryAgainButton : Html Msg
tryAgainButton = 
  H.soloButton "Restart"
    [ Event.onClick ResetSimulation ]


-- Bits of commentary (shown while or after the simulation runs)
    
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

alert : String -> Html msg -- an even stronger sentence.
alert s =
  span []
    [ strong [style [("color", "red")]]
        [text s]
    , br [] []
    ]

{- Display a float with two digits after the decimal point. 
Pluralize the string argument when appropriate. 

    format 1.1 "liter" == "1.1 liters"

(Note that this will only work for words whose plural is <word>s)
-}
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

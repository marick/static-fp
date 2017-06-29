module IVFinal.Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.App.Html as H
import IVFinal.Generic.Measures as Measure

import IVFinal.Types exposing (..)

view : FormData a -> List (Html Msg)
view formData =
  [ div []
      (case formData.stage of
         FormFilling -> fillingView formData
         WatchingAnimation flowRate -> watchingView formData flowRate
         Finished litersDrained -> finishedView formData litersDrained)
  ]



  
type alias InputAttributes =
  { dripRate : List (Attribute Msg)
  , hour : List (Attribute Msg)
  , minute : List (Attribute Msg)
  }

baseView : FormData a -> InputAttributes -> List (Html Msg)
baseView formData {dripRate, hour, minute} = 
  [ H.askFor "Drops per second"
      formData.desiredDripRate
      dripRate
  , H.br
  , H.askFor "Hours" formData.desiredHours hour
  , text " and minutes: "
  , H.textInput formData.desiredMinutes minute
  ]
  

fillingView : FormData a -> List (Html Msg)
fillingView formData =
  baseView formData
    { dripRate =
        [ Event.onInput ChangeDripRate
        , Event.onBlur DrippingRequested
        , autofocus True
        ]
    , hour =
        [ Event.onInput ChangeHours ]
    , minute =
        [Event.onInput ChangeMinutes]
    }
    ++
    [ H.soloButton "Start" 
        [ Event.onClick SimulationRequested ]
    ]
      
staticView : FormData r -> List (Html Msg)
staticView formData =
  baseView formData
    { dripRate = [ readonly True ]
    , hour = [ readonly True ]
    , minute = [ readonly True ]
    }
    
watchingView : FormData r -> Measure.LitersPerMinute -> List (Html Msg)
watchingView formData rate =
  staticView formData
    
finishedView : FormData r -> Measure.Liters -> List (Html Msg)
finishedView formData drained =
  staticView formData
  ++
  [ H.soloButton "Try Again"
      [ Event.onClick ResetSimulation ]
  ]

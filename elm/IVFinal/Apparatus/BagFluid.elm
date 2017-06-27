module IVFinal.Apparatus.BagFluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Ease
import Time exposing (Time)
import Tagged exposing (untag, Tagged(..))

import IVFinal.Model exposing (AnimationModel)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Util.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C
import IVFinal.Util.Measures as Measure

import IVFinal.View.AppSvg as AppSvg exposing ((^^))
import IVFinal.Util.Measures as Measure

---- 

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.bagFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.bagFluid)
    ]

-- Animations
      
drains : Measure.Liters -> Measure.Liters -> Measure.Minutes
       -> AnimationModel
       -> AnimationModel
drains container fluid minutes =
  Animation.interrupt
    [ Animation.toWith
        (draining minutes)
        (drainedStyles container fluid)
    ]
    

-- Styles

animationStyles : Measure.Liters -> Measure.Liters -> List Animation.Property
animationStyles (Tagged container) (Tagged fluid) =
  let
    endingProportion = fluid / container
    rect = C.bag |> Rect.lowerTo endingProportion
  in
    [ Animation.y (Rect.y rect)
    , Animation.height (Animation.px (Rect.height rect))
    ]

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : Measure.Liters -> Measure.Liters -> List Animation.Property
initStyles = animationStyles
  
drainedStyles : Measure.Liters -> Measure.Liters -> List Animation.Property
drainedStyles = animationStyles 
  

-- Timing

draining : Measure.Minutes -> Animation.Interpolation  
draining minutes =
  Animation.easing
    { duration = toSimulationTime minutes
    , ease = Ease.linear
    }



--- Default values and calculations


toSimulationTime : Measure.Minutes -> Time
toSimulationTime (Tagged minutes) =
  Time.minute * (toFloat minutes) / 2000.0 

module IVFinal.Apparatus.BagFluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Ease
import Time exposing (Time)
import Tagged exposing (untag, Tagged(..))

import IVFinal.Types exposing (AnimationModel)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Util.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C
import IVFinal.View.InputFields as Field
import IVFinal.Measures as Measure

import IVFinal.View.AppSvg as AppSvg exposing ((^^))

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.bagFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.bagFluid)
    ]

-- Animations
      
drains : Measure.LitersPerMinute -> Measure.Minutes
       -> AnimationModel
       -> AnimationModel
drains rate minutes =
  Animation.interrupt
    [ Animation.toWith
        (draining minutes)
        (drainedStyles <| finalPercent rate minutes)
    ]
    

-- Styles

animationStyles rect = 
  [ Animation.y (Rect.y rect)
  , Animation.height (Animation.px (Rect.height rect))
  ]
    
initStyles : List Animation.Property
initStyles =
  animationStyles C.bagFluid
  
drainedStyles : Measure.Percent -> List Animation.Property    
drainedStyles (Tagged percent) =
  animationStyles <| Rect.lowerTo percent C.bagFluid 

-- Timing

draining : Measure.Minutes -> Animation.Interpolation  
draining minutes =
  Animation.easing
    { duration = toSimulationTime minutes
    , ease = Ease.linear
    }



--- Default values and calculations

bagLiters = Measure.liters 19.0

finalPercent : Measure.LitersPerMinute -> Measure.Minutes -> Measure.Percent
finalPercent (Tagged rate) (Tagged time) =
  let
    decrease = rate * (toFloat time)
  in
    Measure.percentRemaining (untag bagLiters) decrease

toSimulationTime : Measure.Minutes -> Time
toSimulationTime (Tagged minutes) =
  Time.minute * (toFloat minutes) / 2000.0 

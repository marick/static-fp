module IVFinal.Apparatus.BagFluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Ease
import Time exposing (Time)
import Tagged exposing (untag, Tagged(..))

import IVFinal.Model exposing (..)
import IVFinal.Model exposing (BagFluidData, Model)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Util.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C
import IVFinal.Util.Measures as Measure
import Animation.Messenger 
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
      
drains : Measure.Percent -> Measure.Minutes
       -> (Model -> Model)
       -> (BagFluidData r -> BagFluidData r)
drains percentOfContainer minutes continuation data =
  reanimate data <|
    [ Animation.toWith
        (draining minutes)
        (drainedStyles percentOfContainer)
    , Animation.Messenger.send (NextAnimation continuation) 
    ]

-- Styles

animationStyles : Measure.Percent -> List Animation.Property
animationStyles (Tagged percentOfContainer) =
  let
    rect = C.bag |> Rect.lowerTo percentOfContainer
  in
    [ Animation.y (Rect.y rect)
    , Animation.height (Animation.px (Rect.height rect))
    ]

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : Measure.Percent -> List Animation.Property
initStyles = animationStyles
  
drainedStyles : Measure.Percent -> List Animation.Property
drainedStyles = animationStyles 
  

-- Timing

draining : Measure.Minutes -> Animation.Interpolation  
draining minutes =
  Animation.easing
    { duration = toSimulationTime (Debug.log "min" minutes)
    , ease = Ease.linear
    }



--- Default values and calculations

reanimate data steps =
  { data | bagFluid = Animation.interrupt steps data.bagFluid }


toSimulationTime : Measure.Minutes -> Time
toSimulationTime (Tagged minutes) =
  Time.minute * (toFloat minutes) / 2000.0 

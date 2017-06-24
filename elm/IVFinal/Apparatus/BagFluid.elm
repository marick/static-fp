module IVFinal.Apparatus.BagFluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Ease
import Time
import Tagged exposing (untag)

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

drains : Measure.Percent -> Measure.Minutes -> AnimationModel -> AnimationModel
drains percent minutes =
  Animation.interrupt
    [ Animation.toWith (draining minutes) (drainedStyles percent)
    ]
    

-- Styles
    
initStyles : List Animation.Property
initStyles =
  [ Animation.y (Rect.y C.bagFluid)
  , Animation.height (Animation.px (Rect.height C.bagFluid))
  ]

drainedStyles : Measure.Percent -> List Animation.Property    
drainedStyles percent =
  [ Animation.y <| Rect.y C.bagFluid + 30
  , Animation.height <| (Animation.px ((Rect.height C.bagFluid) - 30))
  ]

-- Timing

draining : Measure.Minutes -> Animation.Interpolation  
draining minutes =
  Animation.easing
    { duration = Time.second * 3
    , ease = Ease.linear
    }


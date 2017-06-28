module IVFinal.Apparatus.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Animation.Messenger
import Ease
import Tagged exposing (untag)
import Time

import IVFinal.Model exposing (AnimationModel)
import IVFinal.Msg exposing (..)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Util.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C
import IVFinal.Util.Measures as Measure
import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Util.AppTagged exposing (UnusableConstructor)


import IVFinal.View.AppSvg as AppSvg exposing ((^^))

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

-- Animations

falls : Measure.DropsPerSecond -> AnimationModel -> AnimationModel
falls rate =
  Animation.interrupt
    (toStart ++ singleDrop rate ++ restartDrop)
      
stops : AnimationModel -> AnimationModel
stops =
  Animation.interrupt toStart

-- Animation helpers

toStart =
  [ Animation.set initStyles ]

singleDrop rate =
  [ Animation.toWith (growing rate) grownStyles
  , Animation.toWith falling fallenStyles
  ]

restartDrop = 
  [ Animation.Messenger.send DrippingRequested
  ]
  

-- Styles
    
initStyles : List Animation.Property
initStyles =
  [ Animation.y (Rect.y C.startingDroplet)
  , Animation.height (px 0)
  ]

grownStyles : List Animation.Property
grownStyles =
  [ Animation.height (px C.dropletSideLength) ]

    
fallenStyles : List Animation.Property
fallenStyles =
  [ Animation.y (Rect.y C.endingDroplet) ]


-- Timing

dropStreamCutoff : Measure.DropsPerSecond
dropStreamCutoff = Measure.dripRate 6.0

-- Following is slower than reality (in a vacuum), but looks better
timeForDropToFall : TimePerDrop
timeForDropToFall = rateToDuration dropStreamCutoff

falling : Animation.Interpolation  
falling =
  Animation.easing
    { duration = untag timeForDropToFall
    , ease = Ease.inQuad
    }

growing : Measure.DropsPerSecond -> Animation.Interpolation  
growing rate =
  let
    duration =
      rate
        |> rateToDuration
        |> Measure.reduceBy timeForDropToFall
  in
    Animation.easing
      { duration = untag duration
      , ease = Ease.linear
      }





--- Support for tagging

type alias TimePerDrop = Tagged TimePerDropTag Float
type TimePerDropTag = TimePerDropTag UnusableConstructor

      
rateToDuration : Measure.DropsPerSecond -> TimePerDrop
rateToDuration dps =
  let
    calculation rate =
      (1 / rate ) * Time.second
  in
    Tagged.map calculation dps |> retag

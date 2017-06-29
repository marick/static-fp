module IVFinal.Apparatus.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Animation.Messenger
import Ease
import Tagged exposing (untag)
import Time

import IVFinal.Types exposing (..)
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
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

-- Animations

tooFastForDiscreteDrops : Measure.DropsPerSecond -> Measure.DropsPerSecond -> Bool
tooFastForDiscreteDrops (Tagged rate) (Tagged cutoff) =
  rate - cutoff > 0

    
falls : Measure.DropsPerSecond -> DropletData r -> DropletData r
falls rate data =
  reanimate data <| 
    case tooFastForDiscreteDrops rate dropStreamCutoff of
      True -> flowSteps rate
      False -> discreteDripSteps rate
       
      
stops : AnimationModel -> AnimationModel
stops =
  Animation.interrupt toStartStep

speedsUp : Measure.DropsPerSecond -> DropletData r -> DropletData r
speedsUp rate data =
  reanimate data <| flowSteps rate
  

slowsDown : Measure.DropsPerSecond -> DropletData r -> DropletData r
slowsDown rate data =
  reanimate data <| discreteDripSteps rate

toStartStep : List AnimationStep
toStartStep =
  [ Animation.set initStyles ]

flowSteps : Measure.DropsPerSecond -> List AnimationStep
flowSteps rate =
  toStartStep ++
    [ Animation.toWith (streaming rate) pouredStyles
    , Animation.loop
      [ Animation.toWith (streaming rate) secondColorStyles
      , Animation.toWith (streaming rate) pouredStyles
      ]
    ]

discreteDripSteps : Measure.DropsPerSecond -> List AnimationStep
discreteDripSteps rate = 
  toStartStep ++
    [ Animation.toWith (growing rate) grownStyles
    , Animation.toWith falling fallenStyles
    , Animation.Messenger.send (StartDripping rate)
    ]

  

-- styles
    
initStyles : List Animation.Property
initStyles =
  [ Animation.y (Rect.y C.startingDroplet)
  , Animation.fill C.fluidColor
  , Animation.height (px 0)
  ]

grownStyles : List Animation.Property
grownStyles =
  [ Animation.height (px C.dropletSideLength) ]

    
fallenStyles : List Animation.Property
fallenStyles =
  [ Animation.y (Rect.y C.endingDroplet) ]

pouredStyles : List Animation.Property
pouredStyles =
  [ Animation.height (px C.streamLength)
  , Animation.fill C.fluidColor
  ]

secondColorStyles : List Animation.Property
secondColorStyles =
  [ Animation.fill C.secondFluidColor
  ]

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

streaming : Measure.DropsPerSecond -> Animation.Interpolation
streaming rate =
  Animation.easing
    { duration = rateToDuration rate |> untag
    , ease = Ease.inQuad
    }

-- Misc

reanimate : DropletData a -> List AnimationStep -> DropletData a
reanimate data steps =
  { data | droplet = Animation.interrupt steps data.droplet }

  

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


      

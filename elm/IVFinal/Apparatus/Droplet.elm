module IVFinal.Apparatus.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Ease
import Tagged exposing (untag)
import Time

import IVFinal.Types exposing (..)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Generic.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C
import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Generic.Tagged exposing (UnusableConstructor)


import IVFinal.App.Svg as AppSvg exposing ((^^))


type alias Obscured model =
  { model
    | droplet : AnimationModel
  }

type alias Transformer model =
  Obscured model -> Obscured model


view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

-- Animations

tooFastToSeeDrops : Measure.DropsPerSecond -> Measure.DropsPerSecond -> Bool
tooFastToSeeDrops (Tagged rate) (Tagged cutoff) =
  rate - cutoff > 0

    
falls : Measure.DropsPerSecond -> Transformer model
falls rate =
  reanimate 
    (case tooFastToSeeDrops rate dropStreamCutoff of
      True -> flowSteps rate
      False -> discreteDripSteps rate)
       
      
stops : AnimationModel -> AnimationModel
stops =
  Animation.interrupt toStartStep

speedsUp : Measure.DropsPerSecond -> Obscured model -> Obscured model
speedsUp rate =
  reanimate <| flowSteps rate
  

slowsDown : Measure.DropsPerSecond -> Transformer model
slowsDown rate =
  reanimate <| discreteDripSteps rate

toStartStep : List AnimationStep
toStartStep =
  [ Animation.set initStyles ]

flowSteps : Measure.DropsPerSecond -> List AnimationStep
flowSteps rate =
  toStartStep ++
    [ Animation.toWith (initialStreaming) pouredStyles
    , Animation.loop
      [ Animation.toWith (streaming rate) secondColorStyles
      , Animation.toWith (streaming rate) pouredStyles
      ]
    ]

discreteDripSteps : Measure.DropsPerSecond -> List AnimationStep
discreteDripSteps rate = 
  toStartStep ++
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith (growing rate) grownStyles
        , Animation.toWith falling fallenStyles
        ]
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

initialStreaming : Animation.Interpolation
initialStreaming =
  Animation.easing
    { duration = Time.second * 0.3
    , ease = Ease.inQuad
    }

-- Misc

reanimate : List AnimationStep -> Transformer model
reanimate steps model =
  { model | droplet = Animation.interrupt steps model.droplet }

  

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


      

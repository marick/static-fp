module IVFinal.Apparatus.Droplet exposing
  (view

  , falls
  , entersTimeLapse
  , leavesTimeLapse

  , initStyles
  )

import IVFinal.App.Animation as AnimationX exposing (FixedPart(..), animatable)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.App.Svg exposing ((^^))
import IVFinal.Generic.EuclideanRectangle as Rect
import IVFinal.Generic.Measures as Measure

import Animation exposing (px)
import Ease
import Svg.Attributes as SA
import Time

import Tagged exposing (Tagged(..), untag, retag)
import IVFinal.Generic.Tagged exposing (UnusableConstructor)

--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | droplet : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | droplet = Animation.interrupt steps model.droplet }


-- Animations

falls : Measure.DropsPerSecond -> Transformer model
falls rate =
  reanimate 
    (case isTooFastToSeeIndividualDrops rate of
      True -> flowSteps rate
      False -> discreteDripSteps rate)
       
      
entersTimeLapse : Measure.DropsPerSecond -> Transformer model
entersTimeLapse rate =
  reanimate <|
    entersTimeLapseSteps ++ flowSteps rate

leavesTimeLapse : Measure.DropsPerSecond -> Transformer model
leavesTimeLapse rate =
  reanimate <|
    leavesTimeLapseSteps ++ discreteDripSteps rate


-- Steps

entersTimeLapseSteps : List AnimationX.Step
entersTimeLapseSteps = 
    [ Animation.set initStyles
    , Animation.toWith (transitioningIn) flowedStyles_1
    ]

flowSteps : Measure.DropsPerSecond -> List AnimationX.Step
flowSteps rate =
    [ Animation.loop
      [ Animation.toWith (flowing rate) flowedStyles_2
      , Animation.toWith (flowing rate) flowedStyles_1
      ]
    ]

discreteDripSteps : Measure.DropsPerSecond -> List AnimationX.Step
discreteDripSteps rate = 
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith (growing rate) grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

leavesTimeLapseSteps : List AnimationX.Step 
leavesTimeLapseSteps =
  [ Animation.toWith (transitioningOut) flowVanishedStyles ] 

-- styles
    
initStyles : List AnimationX.Styling
initStyles =
  [ Animation.y (Rect.y C.startingDroplet)
  , Animation.fill C.fluidColor
  , Animation.height (px 0)
  ]

grownStyles : List AnimationX.Styling
grownStyles =
  [ Animation.height (px C.dropletSideLength) ]
    
fallenStyles : List AnimationX.Styling
fallenStyles =
  [ Animation.y (Rect.y C.endingDroplet) ]

flowedStyles_1 : List AnimationX.Styling
flowedStyles_1 =
  [ Animation.height (px C.flowLength)
  , Animation.fill C.fluidColor
  ]

flowedStyles_2 : List AnimationX.Styling
flowedStyles_2 =
  [ Animation.fill C.secondFluidColor
  ]

flowVanishedStyles : List AnimationX.Styling
flowVanishedStyles =
  [ Animation.height (px 0)
  , Animation.y (Rect.y C.endingDroplet)
  ]


--- Timings

falling : AnimationX.Timing  
falling =
  Animation.easing
    { duration = untag timeForDropToFall
    , ease = Ease.inQuad
    }

growing : Measure.DropsPerSecond -> AnimationX.Timing  
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

flowing : Measure.DropsPerSecond -> AnimationX.Timing
flowing rate =
  Animation.easing
    { duration = rateToDuration rate |> untag
    , ease = Ease.inQuad
    }

transitioningIn : AnimationX.Timing
transitioningIn =
  Animation.easing
    { duration = Time.second * 0.3
    , ease = Ease.inQuad
    }

transitioningOut : AnimationX.Timing
transitioningOut =
  Animation.easing
    { duration = Time.second * 0.1
    , ease = Ease.inQuad
    }

--- View
                    
view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

-- About timing calculations
    
type alias TimePerDrop = Tagged TimePerDropTag Float
type TimePerDropTag = TimePerDropTag UnusableConstructor

flowCutoff : Measure.DropsPerSecond
flowCutoff = Measure.dripRate 6.0

-- Following is slower than reality (in a vacuum), but looks better
timeForDropToFall : TimePerDrop
timeForDropToFall = rateToDuration flowCutoff

rateToDuration : Measure.DropsPerSecond -> TimePerDrop
rateToDuration dps =
  let
    calculation rate =
      (1 / rate ) * Time.second
  in
    Tagged.map calculation dps |> retag
  
isTooFastToSeeIndividualDrops : Measure.DropsPerSecond -> Bool
isTooFastToSeeIndividualDrops (Tagged rate) =
  let
    (Tagged cutoff) = flowCutoff
  in
    rate - cutoff > 0


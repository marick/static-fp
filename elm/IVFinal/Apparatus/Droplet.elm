module IVFinal.Apparatus.Droplet exposing
  (view

  , falls
  , entersTimeLapse
  , leavesTimeLapse

  , initStyles
  )

import IVFinal.App.Animation as AnimationX exposing (FixedPart(..), animatable, px)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.App.Svg exposing ((^^))
import IVFinal.Generic.EuclideanRectangle as Rect
import IVFinal.Generic.Measures as Measure
import Svg.Attributes as SA

import Tagged exposing (Tagged(Tagged))

--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | droplet : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | droplet = AnimationX.interrupt steps model.droplet }


-- Animations

falls : Measure.DropsPerSecond -> Transformer model
falls rate =
  reanimate <| fallsSteps rate
       
      
entersTimeLapse : Measure.DropsPerSecond -> Transformer model
entersTimeLapse rate =
  reanimate <|
    entersTimeLapseSteps ++ flowSteps rate

leavesTimeLapse : Measure.DropsPerSecond -> Transformer model
leavesTimeLapse rate =
  reanimate <|
    leavesTimeLapseSteps ++ fallsSteps rate


-- Steps

fallsSteps : Measure.DropsPerSecond -> List AnimationX.Step
fallsSteps rate = 
  (case isTooFastToSeeIndividualDrops rate of
     True -> flowSteps rate
     False -> discreteDripSteps rate)


entersTimeLapseSteps : List AnimationX.Step
entersTimeLapseSteps =
  let
    timing = AnimationX.accelerating <| Measure.seconds 0.3
  in
    [ AnimationX.set initStyles
    , AnimationX.toWith timing flowedStyles_1
    ]

flowSteps : Measure.DropsPerSecond -> List AnimationX.Step
flowSteps rate =
    [ AnimationX.loop
      [ AnimationX.toWith (flowing rate) flowedStyles_2
      , AnimationX.toWith (flowing rate) flowedStyles_1
      ]
    ]

discreteDripSteps : Measure.DropsPerSecond -> List AnimationX.Step
discreteDripSteps rate = 
    [ AnimationX.loop
        [ AnimationX.set initStyles
        , AnimationX.toWith (growing rate) grownStyles
        , AnimationX.toWith falling fallenStyles
        ]
    ]

leavesTimeLapseSteps : List AnimationX.Step 
leavesTimeLapseSteps =
  let 
    timing = AnimationX.accelerating <| Measure.seconds 0.1
  in
    [ AnimationX.set flowedStyles_1
    , AnimationX.toWith timing flowVanishedStyles
    ] 

-- styles

-- Because some of the `Styles` functions are called from different
-- animation steps, it's safest to make all of them specify all the
-- attributes that `initStyles` does
    
initStyles : List AnimationX.Styling
initStyles =
  [ AnimationX.yFrom C.startingDroplet
  , AnimationX.fill C.fluidColor
  , AnimationX.height (px 0)
  ]

grownStyles : List AnimationX.Styling
grownStyles =
  [ AnimationX.yFrom C.startingDroplet
  , AnimationX.fill C.fluidColor
  , AnimationX.height (px C.dropletSideLength)
  ]
    
fallenStyles : List AnimationX.Styling
fallenStyles =
  [ AnimationX.y (Rect.y C.endingDroplet)
  , AnimationX.fill C.fluidColor
  , AnimationX.height (px C.dropletSideLength)
  ]

flowedStyles_1 : List AnimationX.Styling
flowedStyles_1 =
  [ AnimationX.yFrom C.startingDroplet
  , AnimationX.fill C.fluidColor
  , AnimationX.height (px C.flowLength)
  ]

flowedStyles_2 : List AnimationX.Styling
flowedStyles_2 =
  [ AnimationX.yFrom C.startingDroplet
  , AnimationX.fill C.fluidColor_alternate
  , AnimationX.height (px C.flowLength)
  ]

flowVanishedStyles : List AnimationX.Styling
flowVanishedStyles =
  [ AnimationX.y (Rect.y C.endingDroplet)
  , AnimationX.fill C.fluidColor
  , AnimationX.height (px 0)
  ]


--- Timings

falling : AnimationX.Timing  
falling =
  timeForDropToFall
    |> AnimationX.accelerating 

growing : Measure.DropsPerSecond -> AnimationX.Timing  
growing rate =
  rate
    |> Measure.toSeconds
    |> Measure.reduceBy timeForDropToFall
    |> AnimationX.linear

flowing : Measure.DropsPerSecond -> AnimationX.Timing
flowing rate =
  rate
    |> Measure.toSeconds
    |> AnimationX.linear

--- View
                    
view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

-- About timing calculations
    
flowCutoff : Measure.DropsPerSecond
flowCutoff = Measure.dripRate 6.0

-- Following is slower than reality (in a vacuum), but looks better
timeForDropToFall : Measure.Seconds
timeForDropToFall = Measure.toSeconds flowCutoff

isTooFastToSeeIndividualDrops : Measure.DropsPerSecond -> Bool
isTooFastToSeeIndividualDrops (Tagged rate) =
  let
    (Tagged cutoff) = flowCutoff
  in
    rate - cutoff > 0


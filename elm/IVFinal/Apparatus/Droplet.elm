module IVFinal.Apparatus.Droplet exposing
  (view

  , falls
  , entersTimeLapse
  , leavesTimeLapse
  , stopsDuringTimeLapse

  , initStyles
  )

import IVFinal.Types exposing (Continuation)
import IVFinal.App.Animation as Animation exposing (FixedPart(..), animatable)
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
    | droplet : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | droplet = Animation.interrupt steps model.droplet }


-- Animations

falls : Measure.DropsPerSecond -> Transformer model
falls rate =
  reanimate <| fallsSteps rate
       
      
entersTimeLapse : Measure.DropsPerSecond -> Continuation -> Transformer model
entersTimeLapse rate continuation =
  reanimate <|
    entersTimeLapseSteps rate
    ++ [ Animation.request continuation ]
    ++ flowSteps rate

leavesTimeLapse : Measure.DropsPerSecond -> Transformer model
leavesTimeLapse rate =
  reanimate <|
    leavesTimeLapseSteps ++ fallsSteps rate

stopsDuringTimeLapse : Continuation -> Transformer model
stopsDuringTimeLapse continuation = 
  reanimate <|
    leavesTimeLapseSteps
    ++ [ Animation.request continuation ]

-- Steps

fallsSteps : Measure.DropsPerSecond -> List Animation.Step
fallsSteps rate = 
  (case isTooFastToSeeIndividualDrops rate of
     True -> flowSteps rate
     False -> discreteDripSteps rate)


entersTimeLapseSteps : Measure.DropsPerSecond -> List Animation.Step
entersTimeLapseSteps rate =
  let
    timing = Animation.accelerating <| Measure.seconds 0.3

    noTransition =
      [] -- when already being displayed as flowing

    streamStartsByPouringDown = 
      [ Animation.set initStyles
      , Animation.toWith timing flowedStyles_1
      ]
  in
    case isTooFastToSeeIndividualDrops rate of
      True -> noTransition
      False -> streamStartsByPouringDown
    

flowSteps : Measure.DropsPerSecond -> List Animation.Step
flowSteps rate =
    [ Animation.loop
      [ Animation.toWith (flowing rate) flowedStyles_2
      , Animation.toWith (flowing rate) flowedStyles_1
      ]
    ]

discreteDripSteps : Measure.DropsPerSecond -> List Animation.Step
discreteDripSteps rate = 
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith (growing rate) grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

leavesTimeLapseSteps : List Animation.Step 
leavesTimeLapseSteps =
  let 
    timing = Animation.accelerating <| Measure.seconds 0.1
  in
    [ Animation.set flowedStyles_1
    , Animation.toWith timing flowVanishedStyles
    ] 

-- styles

-- Because some of the `Styles` functions are called from different
-- animation steps, it's safest to make all of them specify all the
-- attributes that `initStyles` does
    
initStyles : List Animation.Styling
initStyles =
  [ Animation.yFrom C.startingDroplet
  , Animation.fill C.fluidColor
  , Animation.heightAttr 0
  ]

grownStyles : List Animation.Styling
grownStyles =
  [ Animation.yFrom C.startingDroplet
  , Animation.fill C.fluidColor
  , Animation.heightAttr C.dropletSideLength
  ]
    
fallenStyles : List Animation.Styling
fallenStyles =
  [ Animation.y (Rect.y C.endingDroplet)
  , Animation.fill C.fluidColor
  , Animation.heightAttr C.dropletSideLength
  ]

flowedStyles_1 : List Animation.Styling
flowedStyles_1 =
  [ Animation.yFrom C.startingDroplet
  , Animation.fill C.fluidColor
  , Animation.heightAttr C.flowLength
  ]

flowedStyles_2 : List Animation.Styling
flowedStyles_2 =
  [ Animation.yFrom C.startingDroplet
  , Animation.fill C.fluidColor_alternate
  , Animation.heightAttr C.flowLength
  ]

flowVanishedStyles : List Animation.Styling
flowVanishedStyles =
  [ Animation.y (Rect.y C.endingDroplet)
  , Animation.fill C.fluidColor
  , Animation.heightAttr 0
  ]


--- Timings

falling : Animation.Timing  
falling =
  timeForDropToFall
    |> Animation.accelerating 

growing : Measure.DropsPerSecond -> Animation.Timing  
growing rate =
  rate
    |> Measure.toSeconds
    |> Measure.reduceBy timeForDropToFall
    |> Animation.linear

flowing : Measure.DropsPerSecond -> Animation.Timing
flowing rate =
  rate
    |> Measure.toSeconds
    |> Animation.linear

--- View
                    
view : Animation.Model -> Svg msg
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


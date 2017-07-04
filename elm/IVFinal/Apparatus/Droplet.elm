module IVFinal.Apparatus.Droplet exposing
  (view

  , falls
  , flows
  , entersTimeLapse
  , transitionsToDripping
  , flowVanishes

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
  case alwaysFlowing rate of
    True -> flows rate
    False -> drips rate

flows : Measure.DropsPerSecond -> Transformer model
flows rate = 
  reanimate <|
    [ Animation.loop
        [ Animation.toWith (flowing rate) flowedStyles_2
        , Animation.toWith (flowing rate) flowedStyles_1
        ]
    ]

drips : Measure.DropsPerSecond -> Transformer model
drips rate = 
  reanimate <|
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith (growing rate) grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

  
entersTimeLapse : Measure.DropsPerSecond -> Continuation -> Transformer model
entersTimeLapse rate continuation =
  reanimate <|
    withoutGlitches rate continuation 
      [ Animation.set initStyles
      , Animation.toWith enterTiming flowedStyles_1
      ]

transitionsToDripping : Measure.DropsPerSecond -> Continuation -> Transformer model
transitionsToDripping rate continuation =
  reanimate <|
    withoutGlitches rate continuation
      [ Animation.set flowedStyles_1
      , Animation.toWith endingTiming flowVanishedStyles
      ] 

flowVanishes : Continuation -> Transformer model
flowVanishes continuation =
  reanimate <|
    [ Animation.set flowedStyles_1
    , Animation.toWith endingTiming flowVanishedStyles
    , Animation.set initStyles
    , Animation.request continuation
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

---- About timing calculations
    
flowCutoff : Measure.DropsPerSecond
flowCutoff = Measure.dripRate 6.0

-- Following is slower than reality (in a vacuum), but looks better
timeForDropToFall : Measure.Seconds
timeForDropToFall = Measure.toSeconds flowCutoff

alwaysFlowing : Measure.DropsPerSecond -> Bool
alwaysFlowing (Tagged rate) =
  let
    (Tagged cutoff) = flowCutoff
  in
    rate - cutoff > 0

withoutGlitches : Measure.DropsPerSecond -> Continuation
                -> List Animation.Step
                -> List Animation.Step
withoutGlitches rate continuation steps =
  let
    continuationRequest =
      [ Animation.request continuation ]

    chosenSteps =
      case alwaysFlowing rate of
        True -> []
        False -> steps
  in
    chosenSteps ++ continuationRequest

enterTiming : Animation.Timing      
enterTiming = 
  Measure.seconds 0.3 |> Animation.accelerating 

endingTiming : Animation.Timing      
endingTiming  =
  Measure.seconds 0.2 |> Animation.accelerating 

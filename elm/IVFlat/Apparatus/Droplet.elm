module IVFlat.Apparatus.Droplet exposing
  (view

  , dripsOrStreams
  , streams
  , entersTimeLapse
  , exitsTimeLapseWithFluidLeft
  , streamVanishesDuringTimeLapse

  , initStyles
  )

{- There are three animation scenarios:

1. A droplet begins to form at the bottom of the bag, then falls into
   the fluid at the bottom of the chamber.

2. The drip rate is fast enough that a second droplet would have to start
   forming (and perhaps start falling) before the previous droplet hits the
   chamber fluid. Rather than have multiple droplets, the image just changes
   to a steady "stream" where movement is suggested by cycling the color
   of a solid rectangle.

3. The simulation has started. The simulation is intended to look like
   time-lapse photography: vastly sped up. The animation is the same as
   a too-fast drip rate.
-}

import IVFlat.Apparatus.Constants as C
import IVFlat.Types exposing (Continuation)

import IVFlat.App.Animation as Animation exposing (FixedPart(..), animatable)
import IVFlat.App.Svg exposing ((^^))
import IVFlat.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFlat.Generic.Measures as Measure

import Svg.Attributes as SA
import Svg as S exposing (Svg)
import Tagged exposing (Tagged(Tagged))
import Color exposing (Color)

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

dripsOrStreams : Measure.DropsPerSecond -> Transformer model
dripsOrStreams rate =
  case alwaysStreaming rate of
    True -> streams rate
    False -> drips rate

{- an undifferentiated stream of fluid - no droplets seen 
-}
streams : Measure.DropsPerSecond -> Transformer model
streams rate = 
  reanimate <|
    [ Animation.loop
        [ Animation.toWith (streaming rate) coloredStreamStyles_2
        , Animation.toWith (streaming rate) coloredStreamStyles_1
        ]
    ]

{- Individual drips
-}    
drips : Measure.DropsPerSecond -> Transformer model
drips rate = 
  reanimate <|
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith (growing rate) grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

{- Used when moving between a dripping-or-streaming state into a
streaming state. The former should show a transitional animation, but
the latter should not (because the before and after images are the
same). Internal utility.
-}
unlessStreaming : Measure.DropsPerSecond -> List Animation.Step -> List Animation.Step
unlessStreaming rate steps =
  case alwaysStreaming rate of
    True -> []
    False -> steps


{- An easy way to tack a continuation onto the end of a series of steps.
Internal utility.
-}
addContinuation : Continuation -> List Animation.Step -> List Animation.Step
addContinuation continuation steps =
  steps ++ [ Animation.request continuation ]


entersTimeLapse : Measure.DropsPerSecond -> Continuation -> Transformer model
entersTimeLapse rate continuation =
  let
    transition = 
      [ Animation.set initStyles
      , Animation.toWith enterTiming coloredStreamStyles_1
      ]
  in
    unlessStreaming rate transition
    |> addContinuation continuation
    |> reanimate

exitsTimeLapseWithFluidLeft : Measure.DropsPerSecond -> Continuation
                            -> Transformer model
exitsTimeLapseWithFluidLeft rate continuation =
  let
    transition =
      [ Animation.set coloredStreamStyles_1
      , Animation.toWith endingTiming streamVanishedStyles
      ]
  in
    unlessStreaming rate transition
      |> addContinuation continuation
      |> reanimate

         
streamVanishesDuringTimeLapse : Continuation -> Transformer model
streamVanishesDuringTimeLapse continuation =
  let
    vanished =
      [ Animation.set coloredStreamStyles_1
      , Animation.toWith endingTiming streamVanishedStyles
      , Animation.set initStyles
      ]
  in
    vanished
      |> addContinuation continuation
      |> reanimate


-- styles

-- Because some of the `Styles` functions are called from different
-- animation steps, it's safest to make all of them specify all the
-- attributes that can ever change.

shape : Rectangle -> Float -> List Animation.Styling
shape ySource height =
  shapePlusColor ySource height C.fluidColor

shapePlusColor : Rectangle -> Float -> Color -> List Animation.Styling
shapePlusColor ySource height color = 
  [ Animation.yFrom ySource
  , Animation.heightAttr height
  , Animation.fill color
  ]

    
initStyles : List Animation.Styling
initStyles =
  shape C.startingDroplet 0

-- ... leads to growth by increasing the height alone:
    
grownStyles : List Animation.Styling
grownStyles =
  shape C.startingDroplet C.dropletSideLength

-- ... leads to falling by moving y down into the chamber fluid
    
fallenStyles : List Animation.Styling
fallenStyles =
  shape C.endingDroplet C.dropletSideLength

-- But droplets that go too fast alternate between this:    
    
coloredStreamStyles_1 : List Animation.Styling
coloredStreamStyles_1 =
  shape C.startingDroplet C.fallingDistance

-- and the same thing with a color change makes it look a bit more
-- like fluid is flowing:
    
coloredStreamStyles_2 : List Animation.Styling
coloredStreamStyles_2 =
  shapePlusColor C.startingDroplet C.fallingDistance C.fluidColor_alternate

-- If the bag runs out (which will always happen during streaming),
-- this shrinks the stream down into the chamber fluid:
    
streamVanishedStyles : List Animation.Styling
streamVanishedStyles =
  shape C.endingDroplet 0


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

streaming : Measure.DropsPerSecond -> Animation.Timing
streaming rate =
  rate
    |> Measure.toSeconds
    |> Animation.linear

enterTiming : Animation.Timing      
enterTiming = 
  Measure.seconds 0.3 |> Animation.accelerating 

endingTiming : Animation.Timing      
endingTiming  =
  Measure.seconds 0.2 |> Animation.accelerating 

---- About timing calculations
    
streamCutoff : Measure.DropsPerSecond
streamCutoff = Measure.dripRate 6.0

-- Following is slower than reality (in a vacuum), but looks better
timeForDropToFall : Measure.Seconds
timeForDropToFall = Measure.toSeconds streamCutoff

alwaysStreaming : Measure.DropsPerSecond -> Bool
alwaysStreaming (Tagged rate) =
  let
    (Tagged cutoff) = streamCutoff
  in
    rate - cutoff > 0



--- View
                    
view : Animation.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

      

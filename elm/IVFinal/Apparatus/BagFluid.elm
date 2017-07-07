module IVFinal.Apparatus.BagFluid exposing
  ( view
  , lowers
  , empties
  , initStyles
  )

{- The bag is the source of fluid. During an animation, the level of
fluid can lower, or the whole bag can empty (which triggers emptying
of the chamber and hose).

Note that the bag may start out not completely filled. There's a
distinction between the "bag" and the "bag fluid".
-}

import IVFinal.Apparatus.CommonFluid as Common
import IVFinal.App.Animation as Animation exposing (FixedPart(..), animatable)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.Types exposing (..)
import IVFinal.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFinal.Generic.Measures as Measure

import Tagged exposing (Tagged(Tagged))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | bagFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | bagFluid = Animation.interrupt steps model.bagFluid }

{- In the real app, draining is proportional to the time the user chose.
Without a spinning clock, that's visually confusing, so all draining takes
this much time.

The client still passes in the time, but it's ignored. (Because I may yet
add the spinning clock.) So this is the duration for all these animations.
-}
duration : Measure.Seconds
duration = Measure.seconds 1.5

-- Animations

lowers : Measure.Percent -> Measure.Minutes -> Continuation
       -> Transformer model
lowers percentOfContainer minutes__ignored_see_above continuation =
  reanimate
    [ Animation.toWith
        (Animation.linear <| Measure.seconds 1.5)
        (percentOfContainerStyles percentOfContainer)
    , Animation.request continuation
    ]

empties : Measure.Minutes -> Continuation
        -> Transformer model
empties =
  lowers (Measure.percent 0) 

-- Styles

initStyles : Measure.Percent -> List Animation.Styling
initStyles = percentOfContainerStyles

{- Note that, unlike the chamber and the hose, the bag doesn't necessarily
start full. That affects the calculations. It works off the *container's*
rectangle, not the fluid's.
-}
percentOfContainerStyles : Measure.Percent -> List Animation.Styling
percentOfContainerStyles (Tagged percentOfContainer) =
  let
    rect = C.bag |> Rect.lowerTo percentOfContainer
  in
    [ Animation.yFrom rect
    , Animation.heightFrom rect
    ]

--
    
view : Animation.Model -> Svg msg
view = Common.view C.bagFluid

module IVFinal.Apparatus.BagFluid exposing
  ( view
  , lowers
  , initStyles
  )

import IVFinal.App.Animation as AnimationX exposing (FixedPart(..), animatable)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.Types exposing (..)
import IVFinal.App.Svg exposing ((^^))
import IVFinal.Generic.EuclideanRectangle as Rect
import IVFinal.Generic.Measures as Measure

import Animation exposing (px)
import Animation.Messenger 
import Ease
import Svg.Attributes as SA
import Time exposing (Time)

import Tagged exposing (untag, Tagged(..))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | bagFluid : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | bagFluid = Animation.interrupt steps model.bagFluid }


-- Animations
      
lowers : Measure.Percent -> Measure.Minutes -> Continuation
       -> Transformer model
lowers percentOfContainer minutes continuation =
  reanimate
    [ Animation.toWith
        (draining minutes)
        (drainedStyles percentOfContainer)
    , Animation.Messenger.send (RunContinuation continuation) 
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : Measure.Percent -> List AnimationX.Styling
initStyles = styles
  
drainedStyles : Measure.Percent -> List AnimationX.Styling
drainedStyles = styles

styles : Measure.Percent -> List AnimationX.Styling
styles (Tagged percentOfContainer) =
  let
    rect = C.bag |> Rect.lowerTo percentOfContainer
  in
    [ Animation.y (Rect.y rect)
    , Animation.height (px (Rect.height rect))
    ]

-- Timing

draining : Measure.Minutes -> AnimationX.Timing  
draining minutes =
  Animation.easing
    { duration = Time.second * 1
    , ease = Ease.linear
    }

---- View

view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.bagFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.bagFluid)
    ]

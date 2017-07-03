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

import Svg.Attributes as SA

import Tagged exposing (Tagged(Tagged))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | bagFluid : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | bagFluid = AnimationX.interrupt steps model.bagFluid }


-- Animations
      
lowers : Measure.Percent -> Measure.Minutes -> Continuation
       -> Transformer model
lowers percentOfContainer minutes continuation =
  reanimate
    [ AnimationX.toWith timeLapsing
        (fluidRemovedStyles percentOfContainer)
    , AnimationX.request continuation
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : Measure.Percent -> List AnimationX.Styling
initStyles = styles
  
fluidRemovedStyles : Measure.Percent -> List AnimationX.Styling
fluidRemovedStyles = styles

styles : Measure.Percent -> List AnimationX.Styling
styles (Tagged percentOfContainer) =
  let
    rect = C.bag |> Rect.lowerTo percentOfContainer
  in
    [ AnimationX.yFrom rect
    , AnimationX.heightFrom rect
    ]

-- Timing

timeLapsing : AnimationX.Timing  
timeLapsing =
  AnimationX.linear <| Measure.seconds 1.5

---- View

view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.bagFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.bagFluid)
    ]

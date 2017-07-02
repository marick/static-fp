module IVFinal.Apparatus.HoseFluid exposing
  ( view
  , empties
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

import Tagged exposing (untag, Tagged(..))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | hoseFluid : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | hoseFluid = AnimationX.interrupt steps model.hoseFluid }


-- Animations
      
empties : Continuation -> Transformer model
empties continuation =
  reanimate
    [ AnimationX.request continuation
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : List AnimationX.Styling
initStyles = 
  [ AnimationX.yFrom C.hoseFluid
  , AnimationX.heightFrom C.hoseFluid
  ]

-- Timing

---- View

view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.hoseFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.hoseFluid)
    ]

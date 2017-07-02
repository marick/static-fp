module IVFinal.Apparatus.ChamberFluid exposing
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
    | chamberFluid : AnimationX.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | chamberFluid = AnimationX.interrupt steps model.chamberFluid }


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
  [ AnimationX.yFrom C.chamberFluid
  , AnimationX.heightFrom C.chamberFluid
  ]

-- Timing

---- View

view : AnimationX.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.chamberFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.chamberFluid)
    ]

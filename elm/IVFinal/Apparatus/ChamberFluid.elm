module IVFinal.Apparatus.ChamberFluid exposing
  ( view
  , empties
  , initStyles
  )

import IVFinal.App.Animation as Animation exposing (FixedPart(..), animatable)
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
    | chamberFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | chamberFluid = Animation.interrupt steps model.chamberFluid }


-- Animations
      
empties : Continuation -> Transformer model
empties continuation =
  reanimate
    [ Animation.request continuation
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : List Animation.Styling
initStyles = 
  [ Animation.yFrom C.chamberFluid
  , Animation.heightFrom C.chamberFluid
  ]

-- Timing

---- View

view : Animation.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.chamberFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.chamberFluid)
    ]

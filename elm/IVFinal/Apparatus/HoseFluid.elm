module IVFinal.Apparatus.HoseFluid exposing
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

--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | hoseFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | hoseFluid = Animation.interrupt steps model.hoseFluid }


-- Animations
      
empties : Continuation -> Transformer model
empties continuation =
  reanimate
    [ Animation.toWith
        (Animation.linear <| Measure.seconds 0.3)
        emptyStyles
    , Animation.request continuation
    ]

-- Styles

initStyles : List Animation.Styling
initStyles = 
  [ Animation.yFrom C.hoseFluid
  , Animation.heightFrom C.hoseFluid
  ]

emptyStyles : List Animation.Styling
emptyStyles  =
  let
    rect = C.hoseFluid |> Rect.lowerTo 0
  in
    [ Animation.yFrom rect
    , Animation.heightAttr 0
    ]

-- Timing

---- View

view : Animation.Model -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.hoseFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.hoseFluid)
    ]

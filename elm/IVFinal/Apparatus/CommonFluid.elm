module IVFinal.Apparatus.CommonFluid exposing
  ( ..
  )

import IVFinal.App.Animation as Animation exposing (FixedPart(..), animatable)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.Types exposing (..)
import IVFinal.App.Svg exposing ((^^))
import IVFinal.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFinal.Generic.Measures as Measure
import Svg.Attributes as SA


emptyStyles : Rectangle -> List Animation.Styling
emptyStyles rect =
  [ Animation.yFrom <| Rect.lowerTo 0 rect
  , Animation.heightAttr 0
  ]


view : Rectangle -> Animation.Model -> Svg msg
view rect =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width rect)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x rect)
    ]


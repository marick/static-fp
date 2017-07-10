module IVFlat.Apparatus.CommonFluid exposing
  ( initStyles
  , emptySteps
  , view
  )

{- The app contains three rectangles that shrink downward to nothingness. 
This module supplies common code to be applied to particular rectangles.
-}

import IVFlat.App.Animation as Animation exposing (FixedPart(..), animatable)
import IVFlat.Apparatus.Constants as C
import Svg exposing (Svg)
import Svg.Attributes exposing (..)

import IVFlat.Types exposing (Continuation)
import IVFlat.App.Svg exposing ((^^))
import IVFlat.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFlat.Generic.Measures as Measure

initStyles : Rectangle -> List Animation.Styling
initStyles rect = 
  [ Animation.yFrom rect
  , Animation.heightFrom rect
  ]

emptySteps : Rectangle -> Measure.Seconds -> Continuation -> List Animation.Step 
emptySteps rect seconds continuation = 
    [ Animation.toWith
        (Animation.linear seconds)
        [ Animation.yFrom <| Rect.lowerTo 0 rect
        , Animation.heightAttr 0
        ]
    , Animation.request continuation
    ]

view : Rectangle -> Animation.Model -> Svg msg
view rect =
  animatable Svg.rect <| HasFixedPart
    [ width ^^ (Rect.width rect)
    , fill C.fluidColorString
    , x ^^ (Rect.x rect)
    ]


module IV.Common.AppAnimation exposing (..)

import Animation
import Animation.Messenger
import IV.Common.EuclideanTypes exposing (..)
import IV.Common.ApparatusConstants as C
import Ease

polygonFromRectangle rect =
  let
    cornerX = rect.origin.x + rect.size.width
    cornerY = rect.origin.y + rect.size.height
  in
    [ (rect.origin.x, rect.origin.y)
    , (cornerX,       rect.origin.y)
    , (cornerX,       cornerY)
    , (rect.origin.x, cornerY)
    ]

dropDescription rectangle color =
  [ Animation.points <| polygonFromRectangle rectangle
  , Animation.fill color
  ]

invisibleDrop = dropDescription C.startingDroplet C.invisibleDropColor
hangingDrop = dropDescription C.startingDroplet C.fluidColor
fallenDrop = dropDescription C.endingDroplet C.fluidColor

fallingDrop =
  let
    dropsPerSecond = 5.0
    growingDrop =
      Animation.easing
        {
          ease = Ease.linear
        , duration = 8.0 - dropsPerSecond
        }
    fallingDrop = 
      Animation.easing
        {
          ease = Ease.inQuad
        , duration = 8.0
        }
  in
    [ Animation.set invisibleDrop
    , Animation.toWith growingDrop hangingDrop
    , Animation.toWith fallingDrop fallenDrop
    ]

  

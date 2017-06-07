module IV.Common.EuclideanRectangle exposing
  ( ..
  )

import IV.Common.EuclideanTypes exposing (..)

fromOrigin : Int -> Int -> Rectangle  
fromOrigin width height =
  { origin = Point 0 0, size = Size width height }

translate { origin, size } shiftBy =
  { origin = Point (origin.x + shiftBy.x) (origin.y + shiftBy.y)
  , size = Size size.width size.height
  }

lower percent { origin, size } =
  let
    shift : Int -> Float -> Int
    shift value byPercent = round (toFloat value * byPercent)

    newY = origin.y + shift size.height (1 - percent)
    newHeight = shift size.height percent
  in
    
    { origin = Point origin.x newY
    , size = Size size.width newHeight
    }

centeredBelow : Rectangle -> Rectangle -> Rectangle
centeredBelow old new =
  let 
    newY = old.origin.y + old.size.height
    oldCenter = old.origin.x + old.size.width // 2
    newX = oldCenter - new.size.width // 2
  in
    translate new (Point newX newY)


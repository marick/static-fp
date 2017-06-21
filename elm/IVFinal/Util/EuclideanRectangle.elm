module IVFinal.Util.EuclideanRectangle exposing
  ( ..
  )

import IVFinal.Util.EuclideanTypes exposing (..)

fromOrigin : Float -> Float -> Rectangle  
fromOrigin width height =
  { origin = Point 0 0, size = Size width height }

translate : Point -> Rectangle-> Rectangle
translate {x, y} { origin, size } =
  { origin = Point (origin.x + x) (origin.y + y)
  , size = Size size.width size.height
  }

nudgeDown : Float -> Rectangle -> Rectangle
nudgeDown i =
  translate (Point 0 i)

lower : Float -> Rectangle -> Rectangle  
lower percent { origin, size } =
  let
    shift value byPercent = value * byPercent

    newY = origin.y + shift size.height (1 - percent)
    newHeight = shift size.height percent
  in
    
    { origin = Point origin.x newY
    , size = Size size.width newHeight
    }

centeredBelow : Rectangle -> Rectangle -> Rectangle
centeredBelow above toBeBelow =
  let 
    newY = above.origin.y + above.size.height
    newX = centerX above toBeBelow
  in
    translate (Point newX newY) toBeBelow

centeredAbove : Rectangle -> Rectangle -> Rectangle
centeredAbove below toBeAbove =
  let 
    newY = below.origin.y - toBeAbove.size.height
    newX = centerX below toBeAbove
  in
    translate (Point newX newY) toBeAbove

centerX : Rectangle -> Rectangle -> Float
centerX existing toBeCentered = 
  let
    existingCenter = existing.origin.x + existing.size.width / 2
  in
    existingCenter - toBeCentered.size.width / 2
          

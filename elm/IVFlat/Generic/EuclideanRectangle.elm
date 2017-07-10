module IVFlat.Generic.EuclideanRectangle exposing
  ( Rectangle
  , x
  , y
  , width
  , height

  , fromOrigin
  , lowerTo
  , nudgeDown
  , centeredBelow
  , centeredAbove
  )

{- An abstract rectangle as Euclid would have described it: just a
bunch of lengths and positions.

Note that the `y` coordinate of a rectangle is the location of its
top, and `height` enxtends downward.
-}

type alias Point = { x : Float, y : Float }
type alias Size = { width : Float, height : Float }            
type alias Rectangle = { origin : Point, size : Size }

-- accessors

x : Rectangle -> Float 
x rect = rect.origin.x

y : Rectangle -> Float 
y rect = rect.origin.y

width : Rectangle -> Float 
width rect = rect.size.width

height : Rectangle -> Float 
height rect = rect.size.height

-- constructors

{- Create a rectangle at the upper left (coordinate 0, 0)
-}

fromOrigin : Float -> Float -> Rectangle  
fromOrigin width height =
  { origin = Point 0 0, size = Size width height }

{- Increase the `y` value of a rectangle.
-}
nudgeDown : Float -> Rectangle -> Rectangle
nudgeDown i =
  translate (Point 0 i)

{- Make the rectangle vertically shorter by decreasing the
`height` and increasing the `y` value. The argument is a value
between 0 and 1, where 1 means "no change", 0.5 means "half the size",
and 1 would produce a degenerate rectangle with no height.
-}
lowerTo : Float -> Rectangle -> Rectangle  
lowerTo percent { origin, size } =
  let
    shift value byPercent = value * byPercent

    newY = origin.y + shift size.height (1 - percent)
    newHeight = shift size.height percent
  in
    
    { origin = Point origin.x newY
    , size = Size size.width newHeight
    }

{- Transform a rectangle to be directly below another (with its top
edge having the same `y` value as the other's bottom edge), with both
rectangles' centers on the same vertical line.

The second parameter is the rectangle being "changed".
-}
centeredBelow : Rectangle -> Rectangle -> Rectangle
centeredBelow above toBeBelow =
  let 
    newY = above.origin.y + above.size.height
    newX = centerX above toBeBelow
  in
    translate (Point newX newY) toBeBelow

{- Transform a rectangle to be directly above another (with its bottom
edge having the same `y` value as the other's top edge), with both
rectangles' centers on the same vertical line.

The second parameter is the rectangle being "changed".
-}
centeredAbove : Rectangle -> Rectangle -> Rectangle
centeredAbove below toBeAbove =
  let 
    newY = below.origin.y - toBeAbove.size.height
    newX = centerX below toBeAbove
  in
    translate (Point newX newY) toBeAbove


-- Helpers
      
centerX : Rectangle -> Rectangle -> Float
centerX existing toBeCentered = 
  let
    existingCenter = existing.origin.x + existing.size.width / 2
  in
    existingCenter - toBeCentered.size.width / 2
          
translate : Point -> Rectangle-> Rectangle
translate {x, y} { origin, size } =
  { origin = Point (origin.x + x) (origin.y + y)
  , size = Size size.width size.height
  }


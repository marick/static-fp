module IvArchitecture.Common.Svg exposing (..)

import Html exposing (Html, div)
import Svg exposing (..)
import Svg.Attributes exposing (..)


(^^) : (String -> a) -> number -> a
(^^) f n =
  f <| toString n

type alias Point = { x : Int, y : Int }
type alias Size = { width : Int, height : Int }            

type alias Rectangle = { origin : Point, size : Size }

rectangle : Int -> Int -> Rectangle  
rectangle width height =
  { origin = Point 0 0, size = Size width height }

translate { origin, size } shiftBy =
  { origin = Point (origin.x + shiftBy.x) (origin.y + shiftBy.y)
  , size = Size size.width size.height
  }

drainTo percent { origin, size } =
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

    
wrapper : List (Svg msg) -> Html msg
wrapper content =
  div [] 
    [ svg
        [ version "1.1"
        , x "0"
        , y "0"
        , width "400px"
        , height "400px"
        ]
        content
    ]



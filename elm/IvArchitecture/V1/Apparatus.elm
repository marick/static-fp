module IvArchitecture.V1.Apparatus exposing (..)

import Svg 
import Svg.Attributes exposing (..)
import IvArchitecture.Common.Svg exposing ((^^))
import IvArchitecture.Common.ApparatusConstants as C

view = 
  [ -- Bag
    fluid C.bagFluid
  , container C.bag
  , tickMarks

  -- Chamber
  , fluid C.chamberFluid
  , container C.chamber

  , container C.hose
  ]

rawRect {origin, size} =
  [ x ^^ origin.x
  , y ^^ origin.y
  , width ^^ size.width
  , height ^^ size.height
  ]

fluidAppearance =
  [ fill C.fluidColorString
  , stroke "none"
  ]

containerAppearance =   
  [ fill "none"
  , stroke "black"
  ]

visibleRectangle coordinates appearance =
  Svg.rect
      (appearance ++ rawRect coordinates) []
  
fluid coordinates =
  visibleRectangle coordinates fluidAppearance
        
container coordinates =
  visibleRectangle coordinates containerAppearance

tickMarks =
  let
    ypos n =
      20 * n
    marking n =
      Svg.line
        [ x1 ^^ 0
        , x2 ^^ 30
        , y1 ^^ ypos n
        , y2 ^^ ypos n
        , stroke "black"
        ] []
  in
    Svg.g [] <| List.map marking (List.range 1 9)

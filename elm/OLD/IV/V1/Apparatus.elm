module IV.V1.Apparatus exposing (..)

import Svg exposing (Svg)
import IV.Common.AppSvg as AppSvg exposing ((^^))
import Svg.Attributes exposing (..)
import IV.Common.ApparatusConstants as C
import IV.Common.EuclideanTypes exposing (..)

view : List (Svg msg)
view = 
  [ -- Hose
    container C.hose
  , fluid C.hose
    
  -- Chamber
  , fluid C.chamberFluid
  , container C.chamber

  -- Bag    
  ,  fluid C.bagFluid
  , container C.bag
  , tickMarks
  ]

fluid : Rectangle -> Svg msg
fluid coordinates =
  AppSvg.rect coordinates C.fluidAppearance

container : Rectangle -> Svg msg
container coordinates =
  AppSvg.rect coordinates C.containerAppearance

tickMarks : Svg msg    
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

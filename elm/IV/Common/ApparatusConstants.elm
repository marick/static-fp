module IV.Common.ApparatusConstants exposing (..)

import Svg
import Svg.Attributes exposing (..)
import IV.Common.EuclideanTypes exposing (..)
import IV.Common.EuclideanRectangle as Rectangle exposing (..)
import Color exposing (Color, rgb)

bag : Rectangle    
bag = Rectangle.fromOrigin 120 200
bagFluid = bag |> Rectangle.lower 0.85
    
-- The chamber is above the hose. Droplets fall into it.
-- It has a puddle in the bottom.
chamber = Rectangle.fromOrigin 30 90 |> centeredBelow bag
chamberFluid = chamber |> lower 0.3

hoseWidth = 10
                           
hose = Rectangle.fromOrigin hoseWidth 90 |> centeredBelow chamber
               
fluidColor : Color
fluidColor = rgb 211 215 207
fluidColorString = "#d3d7cf"     -- Sigh
variantFluidColor = rgb 193 193 193
whiteColor = rgb 255 255 255           

fluidAppearance =
  [ fill fluidColorString
  , stroke "none"
  ]

containerAppearance =   
  [ fill "none"
  , stroke "black"
  ]

             

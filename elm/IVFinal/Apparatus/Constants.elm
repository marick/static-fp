module IVFinal.Apparatus.Constants exposing (..)

import Svg
import Svg.Attributes exposing (..)
import IVFinal.Util.EuclideanTypes exposing (..)
import IVFinal.Util.EuclideanRectangle as Rectangle exposing (..)
import Color exposing (Color, rgb)
import Color.Convert as Convert

bag : Rectangle    
bag = Rectangle.fromOrigin 120 200

bagFluid : Rectangle      
bagFluid = bag |> Rectangle.lower 0.85
    
-- The chamber is above the hose. Droplets fall into it.
-- It has a puddle in the bottom.
chamber : Rectangle
chamber =
  Rectangle.fromOrigin 30 90 |> centeredBelow bag

chamberFluid : Rectangle          
chamberFluid = chamber |> lower 0.3

hoseWidth : Float
hoseWidth = 10

hose : Rectangle            
hose =
  Rectangle.fromOrigin hoseWidth 90 |> centeredBelow chamber

-- The droplet

dropletSideLength : Float
dropletSideLength = hoseWidth

unmovedDroplet : Rectangle
unmovedDroplet = Rectangle.fromOrigin dropletSideLength dropletSideLength

startingDroplet : Rectangle
startingDroplet =
  unmovedDroplet
    |> centeredBelow bag
    -- Grr. Either overlaps the boundary or has small gap above
    |> nudgeDown 1

endingDroplet : Rectangle
endingDroplet =
  unmovedDroplet
    |> centeredAbove chamberFluid
    |> nudgeDown dropletSideLength

-- Utilities for constant transformations
       
fluidAppearance : List (Svg.Attribute msg)
fluidAppearance =
  [ fill <| Convert.colorToHex fluidColor
  , stroke "none"
  ]

containerAppearance : List (Svg.Attribute msg)
containerAppearance =   
  [ fill "none"
  , stroke "black"
  ]

-- Colors


  
fluidColor : Color
fluidColor = rgb 211 215 207

fluidColorString : String
fluidColorString = Convert.colorToHex fluidColor

variantFluidColor : Color                   
variantFluidColor = rgb 193 193 193
                    
variantFluidColorString : String
variantFluidColorString = Convert.colorToHex fluidColor

module IVFinal.Apparatus.Constants exposing (..)

import IVFinal.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import Svg
import Svg.Attributes exposing (..)
import Color exposing (Color, rgb)
import Color.Convert as Convert

bag : Rectangle    
bag = Rect.fromOrigin 120 200

bagFluid : Rectangle      
bagFluid = bag |> Rect.lowerTo 0.85
    
-- The chamber is above the hose. Droplets fall into it.
-- It has a puddle in the bottom.
chamber : Rectangle
chamber =
  Rect.fromOrigin 30 90 |> Rect.centeredBelow bag

chamberFluid : Rectangle          
chamberFluid = chamber |> Rect.lowerTo 0.3

hoseWidth : Float
hoseWidth = 10

hose : Rectangle            
hose =
  Rect.fromOrigin hoseWidth 90 |> Rect.centeredBelow chamber

hoseFluid : Rectangle    
hoseFluid = hose  -- fills entire hose

-- The droplet

dropletSideLength : Float
dropletSideLength = hoseWidth

unmovedDroplet : Rectangle
unmovedDroplet = Rect.fromOrigin dropletSideLength dropletSideLength

startingDroplet : Rectangle
startingDroplet =
  unmovedDroplet
    |> Rect.centeredBelow bag
    -- Grr. Either overlaps the boundary or has small gap above
    |> Rect.nudgeDown 1

endingDroplet : Rectangle
endingDroplet =
  unmovedDroplet
    |> Rect.centeredAbove chamberFluid
    |> Rect.nudgeDown dropletSideLength

flowLength : Float
flowLength = Rect.height chamber - Rect.height chamberFluid
  
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

fluidColorString : String -- Grr
fluidColorString = Convert.colorToHex fluidColor

fluidColor_alternate : Color                   
fluidColor_alternate = rgb 193 193 193

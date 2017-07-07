module IVFinal.Apparatus.Constants exposing
  ( fluidColor
  , fluidColorString
  , fluidColor_alternate

  , bag
  , bagFluid

  , hose
  , hoseFluid

  , chamber
  , chamberFluid 

  , startingDroplet
  , endingDroplet
  , dropletSideLength
  , fallingDistance
  )

{- These are all the values (mainly rectangles with their x, y,
height, and width) that are needed to construct the initial picture of the
apparatus.
-}

import IVFinal.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import Color exposing (Color, rgb)
import Color.Convert as Convert

-- Bag

bag : Rectangle    
bag = Rect.fromOrigin 120 200

bagFluid : Rectangle      
bagFluid = bag |> Rect.lowerTo 0.85


-- Chamber

-- The chamber is above the hose. Droplets fall into it.
-- It has a puddle in the bottom.
chamber : Rectangle
chamber =
  Rect.fromOrigin 30 90 |> Rect.centeredBelow bag

chamberFluid : Rectangle          
chamberFluid = chamber |> Rect.lowerTo 0.3


-- The hose is below the chamber

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

fallingDistance : Float
fallingDistance = Rect.height chamber - Rect.height chamberFluid

-- Colors                  
  
fluidColor : Color
fluidColor = rgb 211 215 207

-- Grr. `Animation` works with `Color` values, but
-- Svg works with strings.
fluidColorString : String
fluidColorString = Convert.colorToHex fluidColor

fluidColor_alternate : Color                   
fluidColor_alternate = rgb 193 193 193

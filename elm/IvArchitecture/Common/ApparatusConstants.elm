module IvArchitecture.Common.ApparatusConstants exposing (..)

import IvArchitecture.Common.Svg exposing (..)
import Color exposing (Color, rgb)

bag : Rectangle    
bag = rectangle 120 200
bagFluid = bag |> drainTo 0.85
    
-- The chamber is above the hose. Droplets fall into it.
-- It has a puddle in the bottom.
chamber = rectangle 30 90 |> centeredBelow bag
chamberFluid = chamber |> drainTo 0.25

hoseWidth = 10
                           
hose = rectangle hoseWidth 90 |> centeredBelow chamber
               
fluidColor : Color
fluidColor = rgb 211 215 207
fluidColorString = "#d3d7cf"     -- Sigh
variantFluidColor = rgb 193 193 193
whiteColor = rgb 255 255 255           

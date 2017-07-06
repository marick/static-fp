module IVFinal.Apparatus.ChamberFluid exposing
  ( view
  , empties
  , initStyles
  )

{-| The chamber is the container that fluid drips into. The only animation
is to drain it out.
-}

import IVFinal.Apparatus.Constants as C
import IVFinal.Apparatus.CommonFluid as Common
import IVFinal.Types exposing (Continuation)

import IVFinal.App.Animation as Animation
import IVFinal.Generic.EuclideanRectangle exposing (Rectangle)
import IVFinal.Generic.Measures as Measure
import Svg exposing (Svg)

--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | chamberFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | chamberFluid = Animation.interrupt steps model.chamberFluid }

fluid : Rectangle
fluid = C.chamberFluid

duration : Measure.Seconds                   
duration = Measure.seconds 0.3

-- Standard functions, customized. You should never need to edit.
      
empties : Continuation -> Transformer model
empties continuation =
  reanimate <|
    Common.emptySteps fluid duration continuation  

initStyles : List Animation.Styling
initStyles = Common.initStyles fluid

view : Animation.Model -> Svg msg
view = Common.view fluid

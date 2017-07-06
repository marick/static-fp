module IVFinal.Apparatus.HoseFluid exposing
  ( view
  , empties
  , initStyles
  )

{-| The hose is at the bottom of the apparatus. The only animation
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
    | hoseFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | hoseFluid = Animation.interrupt steps model.hoseFluid }

fluid : Rectangle
fluid = C.hoseFluid

duration : Measure.Seconds                   
duration = Measure.seconds 0.3

-- Standard functions, customized.

empties : Continuation -> Transformer model
empties continuation =
  reanimate <|
    Common.emptySteps fluid duration continuation  

initStyles : List Animation.Styling
initStyles = Common.initStyles fluid

view : Animation.Model -> Svg msg
view = Common.view fluid

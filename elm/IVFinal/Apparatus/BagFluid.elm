module IVFinal.Apparatus.BagFluid exposing
  ( view
  , lowers
  , initStyles
  )

import IVFinal.Apparatus.CommonFluid as Common
import IVFinal.App.Animation as Animation exposing (FixedPart(..), animatable)
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.Types exposing (..)
import IVFinal.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFinal.Generic.Measures as Measure

import Tagged exposing (Tagged(Tagged))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | bagFluid : Animation.Model
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List Animation.Step -> Transformer model
reanimate steps model =
  { model | bagFluid = Animation.interrupt steps model.bagFluid }

moduleRectangle : Rectangle
moduleRectangle = C.bagFluid


-- Animations
      
lowers : Measure.Percent -> Measure.Minutes -> Continuation
       -> Transformer model
lowers percentOfContainer minutes continuation =
  reanimate
    [ Animation.toWith timeLapsing
        (fluidRemovedStyles percentOfContainer)
    , Animation.request continuation
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : Measure.Percent -> List Animation.Styling
initStyles = styles
  
fluidRemovedStyles : Measure.Percent -> List Animation.Styling
fluidRemovedStyles = styles

styles : Measure.Percent -> List Animation.Styling
styles (Tagged percentOfContainer) =
  let
    rect = C.bag |> Rect.lowerTo percentOfContainer
  in
    [ Animation.yFrom rect
    , Animation.heightFrom rect
    ]

-- Timing

timeLapsing : Animation.Timing  
timeLapsing =
  Animation.linear <| Measure.seconds 1.5

---- View

view : Animation.Model -> Svg msg
view = Common.view moduleRectangle

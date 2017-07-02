module IVFinal.Apparatus.HoseFluid exposing
  ( view
  , empties
  , initStyles
  )

import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.App.Animation as AnimationX
import IVFinal.Apparatus.Constants as C
import Svg as S exposing (Svg)

import IVFinal.Types exposing (..)
import IVFinal.App.Svg exposing ((^^))
import IVFinal.Generic.EuclideanRectangle as Rect
import IVFinal.Generic.Measures as Measure

import Animation exposing (px)
import Animation.Messenger 
import Ease
import Svg.Attributes as SA
import Time exposing (Time)

import Tagged exposing (untag, Tagged(..))


--- Customizing `Model` to this module

type alias Obscured model =
  { model
    | hoseFluid : AnimationModel
  }

type alias Transformer model =
  Obscured model -> Obscured model

reanimate : List AnimationX.Step -> Transformer model
reanimate steps model =
  { model | hoseFluid = Animation.interrupt steps model.hoseFluid }


-- Animations
      
empties : Continuation -> Transformer model
empties continuation =
  reanimate
    [ Animation.Messenger.send (RunContinuation continuation) 
    ]

-- Styles

-- None of the client's business that the same calculations are used
-- for both styles.
    
initStyles : List Animation.Property
initStyles = 
  [ Animation.y (Rect.y C.hoseFluid)
  , Animation.height <| px <| Rect.height C.hoseFluid
  ]

-- Timing

emptying : Measure.Minutes -> Animation.Interpolation  
emptying minutes =
  Animation.easing
    { duration = Time.second * 1
    , ease = Ease.linear
    }

---- View

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.hoseFluid)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.hoseFluid)
    ]

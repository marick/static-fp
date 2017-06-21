module IVFinal.Apparatus.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Time
import Ease 

import IVFinal.Types exposing (AnimationModel)
import IVFinal.Apparatus.AppAnimation exposing (..)
import IVFinal.Util.EuclideanTypes exposing (Rectangle)
import IVFinal.Util.EuclideanRectangle as Rect
import IVFinal.Apparatus.Constants as C

import IVFinal.View.AppSvg as AppSvg exposing ((^^))

falls : AnimationModel -> AnimationModel
falls = 
  Animation.interrupt
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith growing grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

stops : AnimationModel -> AnimationModel
stops =
  Animation.interrupt
    [ Animation.set initStyles ] -- reset back to invisible droplet


    
initStyles : List Animation.Property
initStyles =
  [ Animation.y (Rect.y C.startingDroplet)
  , Animation.height (px 0)
  ]

-- Growing, but still held by surface tension, is simulated by changing opacity.  

grownStyles : List Animation.Property
grownStyles =
  [ Animation.height (px C.dropletSideLength) ]

growing : Animation.Interpolation  
growing =
  Animation.easing
    { duration = Time.second * 0.4
    , ease = Ease.linear
    }

-- Falling is as before, except that I made it faster
    
fallenStyles : List Animation.Property
fallenStyles =
  [ Animation.y (Rect.y C.endingDroplet) ]

falling : Animation.Interpolation  
falling =
  Animation.easing
    { duration = Time.second * 0.3
    , ease = Ease.inQuad
    }


-- Original view is unchanged

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width ^^ (Rect.width C.startingDroplet)
    , SA.fill C.fluidColorString
    , SA.x ^^ (Rect.x C.startingDroplet)
    ]

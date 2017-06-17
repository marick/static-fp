module Animation.A5Fluid.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation
import Time
import Ease 

import Animation.A5Fluid.Types exposing (AnimationModel)
import Animation.A2Tidy.AppAnimation exposing (..)

falls : AnimationModel -> AnimationModel
falls = 
  Animation.interrupt
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.height "20"
    , SA.width "20"
    , SA.fill "grey"
    , SA.x "300"
    ]

initStyles : List Animation.Property
initStyles =
  [ Animation.y 10 ]

fallenStyles : List Animation.Property
fallenStyles =
  [ Animation.y 200 ]

falling : Animation.Interpolation  
falling =
  Animation.easing
    { duration = Time.second * 0.5
    , ease = Ease.inQuad
    }

    

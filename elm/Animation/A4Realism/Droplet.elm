module Animation.A4Realism.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation
import Time
import Ease 

-- All types and utilities are unchanged
import Animation.A2Tidy.Types exposing (AnimationModel)
import Animation.A2Tidy.AppAnimation exposing (..)

-- The description of falling:

falling : Animation.Interpolation  
falling =
  Animation.easing
    { duration = Time.second * 0.5
    , ease = Ease.inQuad
    }

-- Here's the only revised function:

falls : AnimationModel -> AnimationModel
falls = 
  Animation.interrupt
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

-- For comparison, the previous version:    
    
falls__Replaced : AnimationModel -> AnimationModel
falls__Replaced =
  Animation.interrupt
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.to fallenStyles
        ]
    ]

-- Unchanged functions

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

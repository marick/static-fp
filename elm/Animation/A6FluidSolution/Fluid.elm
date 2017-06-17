module Animation.A6FluidSolution.Fluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation
import Time
import Ease 

import Animation.A6FluidSolution.Types exposing (AnimationModel)
import Animation.A2Tidy.AppAnimation exposing (..)

drains : AnimationModel -> AnimationModel
drains =
  Animation.interrupt
    [ Animation.toWith draining drainedStyles
    ]
  

view : AnimationModel -> Svg msg
view =
  animatable S.rect <| HasFixedPart
    [ SA.width "40"
    , SA.x "100"
    , SA.fill "grey"
    ]

initStyles : List Animation.Property
initStyles =
  [ Animation.y 10
  , Animation.height (Animation.px 100)
  ]

drainedStyles : List Animation.Property    
drainedStyles =
  [ Animation.y 110
  , Animation.height (Animation.px 0)
  ]

draining : Animation.Interpolation  
draining =
  Animation.easing
    { duration = Time.second * 3
    , ease = Ease.linear
    }



module Animation.A8Stopping.Fluid exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation
import Animation.Messenger
import Time
import Ease 

import Animation.A8Stopping.Types exposing (AnimationModel, Msg(..))
import Animation.A8Stopping.AppAnimation exposing (..)

drains : AnimationModel -> AnimationModel
drains =
  Animation.interrupt
    [ Animation.toWith draining drainedStyles
    , Animation.Messenger.send StopDroplet             -- added
    ]


-- The rest is unchanged
    

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



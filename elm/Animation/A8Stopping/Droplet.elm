module Animation.A8Stopping.Droplet exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation exposing (px)
import Time
import Ease 

import Animation.A8Stopping.Types exposing (AnimationModel)
import Animation.A8Stopping.AppAnimation exposing (..)


-- We add a new end state:


stops : AnimationModel -> AnimationModel
stops =
  Animation.interrupt
    [ Animation.set initStyles ] -- reset back to invisible droplet
  


--------- Everything below is unchanged



falls : AnimationModel -> AnimationModel
falls = 
  Animation.interrupt
    [ Animation.loop
        [ Animation.set initStyles
        , Animation.toWith growing grownStyles
        , Animation.toWith falling fallenStyles
        ]
    ]

-- The starting droplet is invisible
    
initStyles : List Animation.Property
initStyles =
  [ Animation.y 10
  , Animation.height (px 0)
  ]

grownStyles : List Animation.Property
grownStyles =
  [ Animation.height (px 20) ]

growing : Animation.Interpolation  
growing =
  Animation.easing
    { duration = Time.second * 0.4
    , ease = Ease.linear
    }

-- Falling is as before, except that I made it faster
    
fallenStyles : List Animation.Property
fallenStyles =
  [ Animation.y 200 ]

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
    [ SA.width "20"
    , SA.fill "grey"
    , SA.x "300"
    ]

    

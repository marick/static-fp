module Animation.A2TidyAlternate.Droplet exposing
  ( falls
  , view
  , initStyles
  )

-- The only change here is on line 23, in the call to `animatable`.

import Animation.A2Tidy.Types exposing (AnimationModel)
import Animation.A2TidyAlternate.AppAnimation exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation

falls : AnimationModel -> AnimationModel
falls =
  Animation.interrupt
    [ Animation.to fallenStyles ]

view : AnimationModel -> Svg msg
view =
  animatable (Shape S.rect) <| HasFixedPart
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

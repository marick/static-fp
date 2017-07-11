module Animation.A2Tidy.Droplet exposing
  ( falls
  , view
  , initStyles
  )

import Animation.A2Tidy.Types exposing (AnimationModel)
import Animation.A2Tidy.AppAnimation exposing (..)

import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation

falls : AnimationModel -> AnimationModel
falls =
  Animation.interrupt
    [ Animation.to fallenStyles ]

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

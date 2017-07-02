module IVFinal.App.Animation exposing (..)

import IVFinal.Types exposing (Msg(RunContinuation))
import Svg exposing (Svg)
import Animation
import Animation.Messenger
import Ease
import Time
import IVFinal.Generic.EuclideanRectangle as Rect

-- Tag attributes (including styles) that a particular shape
-- never animates.
type FixedPart msg =
  HasFixedPart (List (Svg.Attribute msg))

type alias Shape msg =
  List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
  
animatable : Shape msg -> FixedPart msg -> Model
          -> Svg msg
animatable shape (HasFixedPart attributes) animatedPart =
  shape
    (attributes ++ Animation.render animatedPart)
    []


timing ease seconds = 
  Animation.easing
    { duration = Time.second * seconds
    , ease = ease
    }
      
linear = timing Ease.linear
accelerating = timing Ease.inQuad


yFrom = Rect.y >> Animation.y
heightFrom = Rect.height >> px >> Animation.height
requestContinuation = RunContinuation >> Animation.Messenger.send

-- Aliasing

type alias Styling = Animation.Property
type alias Timing = Animation.Interpolation  
type alias Model = Animation.Messenger.State Msg
type alias Step = Animation.Messenger.Step Msg



-- re-exports

height = Animation.height
fill = Animation.fill
px = Animation.px

interrupt = Animation.interrupt
loop = Animation.loop
send = Animation.Messenger.send
set = Animation.set
toWith = Animation.toWith

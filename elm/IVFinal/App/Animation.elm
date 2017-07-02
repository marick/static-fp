module IVFinal.App.Animation exposing (..)

import IVFinal.Types exposing (Msg(RunContinuation), Continuation)
import Svg exposing (Svg)
import Animation
import Animation.Messenger
import Ease
import Time
import IVFinal.Generic.EuclideanTypes exposing (Rectangle)
import IVFinal.Generic.EuclideanRectangle as Rect
import Color exposing (Color)

-- Aliasing

type alias Styling = Animation.Property
type alias Timing = Animation.Interpolation  
type alias Model = Animation.Messenger.State Msg
type alias Step = Animation.Messenger.Step Msg

type alias EasingFunction = Float -> Float      

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

timing : EasingFunction -> Float -> Timing
timing ease seconds = 
  Animation.easing
    { duration = Time.second * seconds
    , ease = ease
    }
      
linear : Float -> Timing
linear = timing Ease.linear

accelerating : Float -> Timing
accelerating = timing Ease.inQuad

yFrom : Rectangle -> Styling
yFrom = Rect.y >> Animation.y

heightFrom : Rectangle -> Styling
heightFrom = Rect.height >> px >> Animation.height

request : Continuation -> Step             
request = RunContinuation >> Animation.Messenger.send


-- re-exports

height : Animation.Length -> Styling
height = Animation.height

fill : Color -> Styling          
fill = Animation.fill

px : Float -> Animation.Length       
px = Animation.px

y : Float -> Styling     
y = Animation.y

interrupt : List Step -> Model -> Model
interrupt = Animation.interrupt

loop : List Step -> Step
loop = Animation.loop

send : Msg -> Step       
send = Animation.Messenger.send

set : List Styling -> Step
set = Animation.set

toWith : Timing -> List Styling -> Step      
toWith = Animation.toWith

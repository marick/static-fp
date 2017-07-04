module IVFinal.App.Animation exposing (..)

import IVFinal.Types as App
import Svg exposing (Svg)
import Animation
import Animation.Messenger
import Ease
import Time
import IVFinal.Generic.Measures as Measure
import IVFinal.Generic.EuclideanTypes exposing (Rectangle)
import IVFinal.Generic.EuclideanRectangle as Rect
import Color exposing (Color)
import Tagged exposing (Tagged(Tagged))


-- Aliasing

type alias Styling = Animation.Property
type alias Timing = Animation.Interpolation  
type alias Model = Animation.Messenger.State App.Msg
type alias Step = Animation.Messenger.Step App.Msg
type alias Msg = Animation.Msg

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

timing : EasingFunction -> Measure.Seconds -> Timing
timing ease (Tagged seconds) = 
  Animation.easing
    { duration = Time.second * seconds
    , ease = ease
    }
      
linear : Measure.Seconds -> Timing
linear = timing Ease.linear

accelerating : Measure.Seconds -> Timing
accelerating = timing Ease.inQuad

yFrom : Rectangle -> Styling
yFrom = Rect.y >> y

heightFrom : Rectangle -> Styling
heightFrom = Rect.height >> heightAttr

request : App.Continuation -> Step             
request = App.RunContinuation >> Animation.Messenger.send


-- re-exports

{- Animation.height produces a *style* "height: xyzzy". But, for SVG,
   we want the height *attribute*. I didn't override the name `height`
   because that would be confusing if someone used this code to animate
   HTML.
-}
heightAttr : Float -> Styling
heightAttr val = Animation.attr "height" val "px"

fill : Color -> Styling          
fill = Animation.fill

y : Float -> Styling     
y = Animation.y

interrupt : List Step -> Model -> Model
interrupt = Animation.interrupt

loop : List Step -> Step
loop = Animation.loop

send : App.Msg -> Step       
send = Animation.Messenger.send

set : List Styling -> Step
set = Animation.set

toWith : Timing -> List Styling -> Step      
toWith = Animation.toWith

style : List Styling -> Model
style = Animation.style

update : Animation.Msg -> Model -> (Model, Cmd App.Msg)
update = Animation.Messenger.update

subscription : (Animation.Msg -> App.Msg) -> List Model -> Sub App.Msg
subscription = Animation.subscription
               

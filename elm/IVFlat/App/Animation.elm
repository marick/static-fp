module IVFlat.App.Animation exposing (..)

{- A facade over the different pieces used to implement animations. 
Specifically, the first block of imports. Also some obsessive tweaking of
type names.
-}

import IVFlat.Generic.EuclideanRectangle as Rect exposing (Rectangle)
import IVFlat.Generic.Measures as Measure
import IVFlat.Types as App

import Animation
import IVFlat.Generic.Animation as MoreAnimation
import Animation.Messenger
import Ease
import Time
import Svg exposing (Svg)
import Color exposing (Color)
import Tagged exposing (Tagged(Tagged))
import IVFlat.Generic.Lens as Lens exposing (Lens)

-- Aliasing

type alias Styling = Animation.Property
type alias Timing = Animation.Interpolation  
type alias Model = Animation.Messenger.State App.Msg
type alias Step = Animation.Messenger.Step App.Msg
type alias Msg = Animation.Msg

type alias EasingFunction = Float -> Float


{- A little DSL for defining an animatable shape

   animatable S.rect <| HasFixedPart
     [ SA.width ^^ Rect.width C.startingDroplet
     , SA.x ^^ Rect.x C.startingDroplet
     ]
-}
animatable : Shape msg -> FixedPart msg -> Model
          -> Svg msg
animatable shape (HasFixedPart attributes) animatedPart =
  shape
    (attributes ++ Animation.render animatedPart)
    []

type alias Shape msg =
  List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
  
{- A "keyword argument" for the parts of the shape that never change.
-}
type FixedPart msg =
  HasFixedPart (List (Svg.Attribute msg))


-- Some shorthand for specifying timing    

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


-- Shorthand, since we frequently grab values from rectangles
               
yFrom : Rectangle -> Styling
yFrom = Rect.y >> y

heightFrom : Rectangle -> Styling
heightFrom = Rect.height >> heightAttr



{- In multi-stage animation, continuations are used to send a
`Msg` (`RunContinuation`) that starts the next set of animations. 
This, I hope, makes their use more clear.

    [ Animation.set flowedStyles_1
    , Animation.toWith endingTiming flowVanishedStyles
    , Animation.set initStyles
    , Animation.request continuation     -----------------<<<
    ] 
-}
request : App.Continuation -> Step             
request = App.RunContinuation >> Animation.Messenger.send


-- Attributes and styles

{- Animation.height produces a *style* "height: xyzzy". But, for SVG,
we want the height *attribute*. I didn't override the name `height`
because that would be confusing if someone used this code to animate
HTML.

    [ Animation.yFrom C.startingDroplet
    , Animation.fill C.fluidColor
    , Animation.heightAttr C.dropletSideLength  --------<<<
    ]
-}
heightAttr : Float -> Styling
heightAttr val = Animation.attr "height" val "px"


-- Re-exports

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
               
updateAnimations : Msg -> App.Model
                 -> List (Lens App.Model Model)
                 -> (App.Model, Cmd App.Msg)
updateAnimations = MoreAnimation.updateAnimations

-- an alternate implementation
updateAnimations2 : Msg -> App.Model
                  -> List (Lens App.Model Model)
                  -> (App.Model, Cmd App.Msg)
updateAnimations2 = MoreAnimation.updateAnimations2
                 

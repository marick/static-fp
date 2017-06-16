module Animation.MessengerCommon exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as Event
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation
import Animation.Messenger
import Time
import Ease 


type Msg
  = Start
  | Tick Animation.Msg
  | Stop

type alias AnimationModel = Animation.Messenger.State Msg


-- Used in Droplet.elm

wrapper : List (Html msg) -> Html msg
wrapper contents = 
  H.div
    [ HA.style [("margin", "4em")]]
    contents
      
canvas : List (Svg msg) -> Html msg
canvas contents =       
  S.svg 
    [ SA.version "1.1"
    , SA.width "400"
    , SA.height "400"
    ]
    contents

button : msg -> String -> Html msg
button onClick text =       
  H.button
    [ Event.onClick onClick
    , HA.style [ ("position", "absolute")
               , ("font-size", "1.5em")
               ]
    ]
    [H.strong [] [H.text text]]



-- Added for DropletPrettier.elm

type alias Shape msg =
  List (S.Attribute msg) -> List (Svg msg) -> Svg msg

type alias StaticAttributes msg = List (S.Attribute msg)

animatable : Shape msg -> StaticAttributes msg -> AnimationModel
           -> Svg msg
animatable shape staticPart animatedPart =
  shape
    (staticPart ++ Animation.render animatedPart)
    []

hasStaticPart : List (S.Attribute msg) -> List (S.Attribute msg)
hasStaticPart = identity
      
dropletView : AnimationModel -> Svg msg
dropletView =
  animatable S.rect <| hasStaticPart
    [ SA.height "20"
    , SA.width "20"
    , SA.fill "grey"
    , SA.x "300"
    ]

dropletInitStyles : List Animation.Property    
dropletInitStyles =
  [ Animation.y 10 ]

dropletFallenStyles : List Animation.Property    
dropletFallenStyles =
  [ Animation.y 200 ]


-- Added for DropletEasing.elm

dropletControl : Animation.Interpolation  
dropletControl =
  Animation.easing
    { duration = Time.second * 0.5
    , ease = Ease.inQuad
    }


-- Added for Fluid exercise

fluidView : AnimationModel -> Svg msg
fluidView =
  animatable S.rect <| hasStaticPart
    [ SA.width "40"
    , SA.x "100"
    , SA.fill "grey"
    ]

fluidInitStyles : List Animation.Property
fluidInitStyles =
  [ Animation.y 10
  , Animation.height (Animation.px 100)
  ]

fluidLastStyles : List Animation.Property    
fluidLastStyles =
  [ Animation.y 110
  , Animation.height (Animation.px 0)
  ]

fluidControl : Animation.Interpolation  
fluidControl =
  Animation.easing
    { duration = Time.second * 3
    , ease = Ease.linear
    }


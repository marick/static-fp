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

type alias FigureFunction msg =
  (List (S.Attribute msg) -> List (Svg msg) -> Svg msg)

type alias StaticAttributes msg = List (S.Attribute msg)

animatable : FigureFunction msg -> StaticAttributes msg -> Animation.Messenger.State msg
           -> Svg msg
animatable figure staticPart animatedPart =
  figure
    (staticPart ++ Animation.render animatedPart)
    []

hasStaticPart : List (S.Attribute msg) -> List (S.Attribute msg)
hasStaticPart = identity
      
droplet : Animation.Messenger.State msg -> Svg msg
droplet =
  animatable S.rect <| hasStaticPart
    [ SA.height "20"
    , SA.width "20"
    , SA.fill "grey"
    , SA.x "300"
    ]

dropletStart : List Animation.Property    
dropletStart =
  [ Animation.y 10 ]

dropletEnd : List Animation.Property    
dropletEnd =
  [ Animation.y 200 ]

      
-- Added for DropletUnidiomatic.elm

noCmd : model -> (model, Cmd msg)
noCmd model =
  (model, Cmd.none)


-- Added for DropletEasing.elm

dropletControl : Animation.Interpolation  
dropletControl =
  Animation.easing
    { duration = Time.second * 0.5
    , ease = Ease.inQuad
    }




-- Added for Fluid exercise

fluid : Animation.Messenger.State msg -> Svg msg
fluid =
  animatable S.rect <| hasStaticPart
    [ SA.width "40"
    , SA.x "100"
    , SA.fill "grey"
    ]

fluidStart : List Animation.Property
fluidStart =
  [ Animation.y 10
  , Animation.height (Animation.px 100)
  ]

fluidEnd : List Animation.Property    
fluidEnd =
  [ Animation.y 110
  , Animation.height (Animation.px 0)
  ]

fluidControl : Animation.Interpolation  
fluidControl =
  Animation.easing
    { duration = Time.second * 3
    , ease = Ease.linear
    }


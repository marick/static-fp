module Animation.DropletExtreme exposing (..)

import Html as H exposing (Html)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Animation.Common as C
import Animation

type alias Model =
  { dropletAnimatables : Animation.State
  }

startDroplet : Animation.State -> Animation.State
startDroplet previousAnimation  =
  Animation.interrupt
    [ Animation.to C.dropletEnd ]
    previousAnimation
  
-- The usual functions
  
type Msg
  = Start
  | Tick Animation.Msg

init : (Model, Cmd Msg)
init = ( { dropletAnimatables = Animation.style C.dropletStart }
       , Cmd.none
       )

updateDroplet : (Animation.State -> Animation.State) -> Model -> Model
updateDroplet f model =
  { model |
      dropletAnimatables = f model.dropletAnimatables
  }
  
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      model
        |> updateDroplet startDroplet
        |> C.noCmd
           
    Tick animationMsg ->
      model
        |> updateDroplet (Animation.update animationMsg)
        |> C.noCmd

view : Model -> Html Msg
view model =
  C.wrapper
    [ C.canvas [C.droplet model.dropletAnimatables]
    , C.button Start "Start"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.dropletAnimatables ]

    
main : Program Never Model Msg
main =
  H.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

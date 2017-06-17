module Animation.A3Repeating exposing (main)

import Animation.A2Tidy.Types exposing (..)
import Animation.A3Repeating.Droplet as Droplet

import Animation.Layout as Layout
import Html exposing (Html)
import Animation

{-


    There is no difference between this and the previous version.


-}

init : (Model, Cmd Msg)
init = ( { droplet = Animation.style Droplet.initStyles }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start ->
      ( { model | droplet = Droplet.falls model.droplet }
      , Cmd.none
      )
           
    Tick subMsg ->
      ( { model | droplet = Animation.update subMsg model.droplet }
      , Cmd.none
      )

view : Model -> Html Msg
view model =
  Layout.wrapper
    [ Layout.canvas [ Droplet.view model.droplet ]
    , Layout.button Start "Click Me"
    ]

subscriptions : Model -> Sub Msg    
subscriptions model =
  Animation.subscription Tick [ model.droplet ]

    
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
    

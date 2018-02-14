module Architecture1.UserInput exposing (..)

import Html exposing (..)
import Html.Events as Event
import Html.Attributes exposing (..)
import Random
import Architecture1.Style as Style
import Time exposing (Time, every, second)

type alias Model = Int

type Msg
  = ProduceRandomValue Time 
  | HandleRandomValue Int

init : (Model, Cmd Msg)
init = (0, askForTuple)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProduceRandomValue _ ->
      (model, askForTuple)
        
    HandleRandomValue model ->
      ( model
      , Cmd.none
      )

askForTuple : Cmd Msg
askForTuple =
--  Generate (map tagger generator)
  
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view model =
  div []
    [ text <| toString model ]

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions _ = 
  every second ProduceRandomValue

-- Main

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

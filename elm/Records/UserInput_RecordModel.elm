module Architecture1.UserInput_AddNumber exposing (..)

import Html exposing (..)
import Html.Events as Event
import Html.Attributes exposing (..)
import Random
import Architecture1.Style as Style
import Time exposing (Time, every, second)

-- Model

type alias Model =
  { displayValue : Int
  , iteration : Int
  }

-- Msg  

type Msg
  = ProduceRandomValue Time 
  | HandleRandomValue Int

-- Update

init : (Model, Cmd Msg)
init = ( Model 0 0, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProduceRandomValue _ ->
      (model, askForRandomValue)
        
    HandleRandomValue value ->
      ( { model |
            displayValue = model.displayValue + value, 
            iteration = model.iteration + 1
        }
      , Cmd.none
      )

askForRandomValue : Cmd Msg
askForRandomValue =
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view model =
  div []
    [ button [Event.onClick (HandleRandomValue 11111)] [text "Add"]
    , div [ Style.iteratedText model.iteration ]
      [ text <| toString model.displayValue ]
    ]

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

module Architecture1.IncreaseChoiceSolution
  exposing (..)

import Html exposing (..)
import Html.Events as Event
import Html.Attributes exposing (..)
import Random
import Architecture1.Style as Style
import Time exposing (Time, every, second)

-- Model

type alias DisplayValue = Int
type alias Iteration = Int
type Model = Model DisplayValue Iteration

includeRandomValue : Int -> Model -> Model
includeRandomValue randomValue (Model displayValue iteration) =
  Model (displayValue + randomValue) (iteration + 1)

negateDisplayValue : Model -> Model
negateDisplayValue (Model displayValue iteration) = 
  Model (negate displayValue) iteration

-- Msg  

type Msg
  = ProduceRandomValue Time 
  | HandleRandomValue Int
  | Negate

-- Update

init : (Model, Cmd Msg)
init = (Model 0 0, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProduceRandomValue _ ->
      (model, askForRandomValue)
        
    HandleRandomValue value ->
      ( includeRandomValue value model
      , Cmd.none
      )

    Negate ->
      ( negateDisplayValue model
      , Cmd.none
      )

askForRandomValue : Cmd Msg
askForRandomValue =
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view (Model displayValue iteration) =
  div []
    [ button [Event.onClick (HandleRandomValue 11111)] [text "Increase"]
    , div [ Style.iteratedText iteration ]
      [ text <| toString displayValue ]
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

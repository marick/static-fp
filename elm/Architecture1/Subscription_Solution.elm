module Architecture1.Subscription_Solution exposing (..)

import Html exposing (..)
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

-- Msg  

type Msg
  = ProduceRandomValue Time 
  | HandleRandomValue Int

-- Update

-- Note: always showing 0 when the program starts would be boring,
-- so ask for a random number right away.
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

askForRandomValue : Cmd Msg
askForRandomValue =
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view (Model displayValue iteration) =
  div [ Style.iteratedText iteration ]
    [ text <| toString displayValue ]

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

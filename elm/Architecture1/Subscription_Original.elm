module Architecture1.Subscription_Original exposing (..)

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
    
init : (Model, Cmd Msg)
init = (Model 0 0, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProduceRandomValue _ ->
      (model, Cmd.none)
        
    HandleRandomValue value ->
      ( includeRandomValue value model
      , askForRandomValue
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

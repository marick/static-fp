module Architecture1.UserInput_AddNumber exposing (..)

import Html exposing (..)
import Html.Events as Event
import Html.Attributes exposing (..)
import Random
import Architecture1.Style as Style
import Time exposing (Time, every, second)

-- Model

type alias DisplayValue = Int
type alias Iteration = Int
type alias IncrementChoice = Int 
type Model = Model DisplayValue Iteration IncrementChoice

addValue : Int -> Model -> Model
addValue value (Model displayValue iteration choice) =
  Model (displayValue + value) (iteration + 1) choice

includeUserChoice : IncrementChoice -> Model -> Model
includeUserChoice choice (Model displayValue iteration _) =
  Model displayValue iteration choice

userChoice (Model _ _ 

-- Msg  

type Msg
  = ProduceRandomValue Time 
  | HandleRandomValue Int
  | UserChoseIncrement Int
  | ApplyUserIncrement

-- Update

firstChoice = 11111
incrementChoices = [ firstChoice, 9990000 ]

init : (Model, Cmd Msg)
init = (Model 0 0 firstChoice, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ProduceRandomValue _ ->
      (model, askForRandomValue)
        
    HandleRandomValue value ->
      ( addValue value model
      , Cmd.none
      )

    UserChoseIncrement choice ->
      ( includeUserChoice choice model
      , Cmd.none
      )

    AppyUserIncrement ->
      ( addValue 
        

askForRandomValue : Cmd Msg
askForRandomValue =
  Random.generate HandleRandomValue (Random.int 0 5)

-- View
      
view : Model -> Html Msg
view (Model displayValue iteration _) =
  div []
    [ numberChooser
    , button [Event.onClick ApplyUserIncrement] [text "Add"]
    , div [ Style.iteratedText iteration ]
      [ text <| toString displayValue ]
    ]

numberChooser : Html Msg
numberChooser =
  fieldset [] (List.map numberChoice incrementChoices)

numberChoice : Int -> Html Msg
numberChoice value =
  label []
    [ input
        [ type_ "radio"
        , Event.onClick <| UserChoseIncrement value
        , selected False
        ] []
    , text <| toString value
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

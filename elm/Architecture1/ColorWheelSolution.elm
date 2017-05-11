module Architecture1.ColorWheelSolution exposing (..)

{-                                   WARNING

     When run, this code causes a strobing effect.
     See `========WARNING-READ-THIS========.txt` in this directory 
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Random
import Architecture1.Style as Style

-- Model

type alias DisplayValue = Int
type alias Iteration = Int
type Model = Model DisplayValue Iteration

includeRandomValue : Int -> Model -> Model
includeRandomValue randomValue (Model displayValue iteration) =
  Model (displayValue + randomValue) (iteration + 1)

-- Msg  

type Msg
  = HandleRandomValue Int

-- Update
    
init : (Model, Cmd Msg)
init = (Model 0 0, askForRandomValue)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
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

-- Main
      
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }
